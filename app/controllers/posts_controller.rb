class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  ## added Vary header to avoid browser caching and rendering json on back nav
  ## if it stops working use different urls for AJAX calls 

  # GET /posts
  # GET /posts.json
  def index
    #top level posts
    @active_nav = 0 #for header component prop
    prepare_posts("top_level")
    respond_to do |format|
      format.html {render component: 'PostsBody', 
                          props: { 
                            postSet: "discussionTopics",
                            posts: @top_level_posts_json
                            } 
                          }
      format.json {
        set_vary_header
        render :json => @top_level_posts_json
      }
    end
  end

  def master
    #all posts
    prepare_posts("all")
    respond_to do |format|
      format.html {render component: 'PostsBody', 
                          props: { 
                            postSet: "master",
                            posts: @total_posts_json
                            } 
                          }
      format.json {
        set_vary_header
        render :json => @total_posts_json
      }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    prepare_posts(@post.id)
    respond_to do |format|
      format.html {render component: 'PostsBody', 
                          props: { 
                            postSet: "individualFamily",
                            posts: @post_family
                            } 
                          }
      format.json {
        set_vary_header
        render :json => @post_family
      }
    end
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.save
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Post was successfully created.' }
      format.json { 
        set_vary_header
        render :show, status: :ok, location: @post 
      }
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { 
          set_vary_header
          render :show, status: :ok, location: @post 
        }
      else
        format.html { render :edit }
        format.json { 
          set_vary_header
          render json: @post.errors, status: :unprocessable_entity 
        }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find_by(post_params)
    @post.update(:is_deleted => TRUE)
    ## can refactor with rebuild of index jbuilder
    render :json => prepare_posts("all")
  end

  private

    def set_vary_header
       response.headers['Vary'] = 'Accept'
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def prepare_posts(post_set)
      #replace ordering by :created_at with ranking algo
      case post_set
      when "top_level"
        @top_level_posts_json = Post.top_level_posts_json
      when "all"
        ## makes hash 
        @total_posts_json = Post.make_master_json
      else ##id 
        @post_family = Post.individual_to_json(post_set)
      end
    end

    def post_params
      params.require(:post).permit(:id, :text, :parent_id)
    end
    
end
