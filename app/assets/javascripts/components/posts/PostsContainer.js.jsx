var PostsContainer = React.createClass({

  render() {

    return (

      <div>
        { this.props.posts.map(function(post, children) {
          var key = +Object.keys(post)[0];

          return <div 
                    className="posts"
                    key={"post-family-" + post[key].id}
                 >
                 <Post
                    key={"post-" + post[key].id}
                    id={post[key].id}
                    isTopLevel={post[key].is_top_level}
                    text={post[key].text}
                    author={post[key].author}
                    authorID={post[key].author_id}
                    created={post[key].created_at}
                    edited={post[key].updated_at}
                    replyToPost={this.props.replyToPost}
                    deletePost={this.props.deletePost}
                    postSet={this.props.postSet}
                    currentUserID={this.props.currentUserID}
                 />
                 <PostsContainer
                    key={"children-of-" + post[key].id}
                    posts={post[key].children}
                    replyToPost={this.props.replyToPost}
                    deletePost={this.props.deletePost}
                    postSet={this.props.postSet}
                    currentUserID={this.props.currentUserID}
                 />
                 </div>

        }.bind(this))}
      </div>
    )
  }
});

PostsContainer.propTypes = {
  posts: React.PropTypes.array.isRequired,
  postSet: React.PropTypes.string.isRequired,
  replyToPost: React.PropTypes.func.isRequired,
  deletePost: React.PropTypes.func.isRequired
};