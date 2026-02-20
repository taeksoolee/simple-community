class CommentsController < ApplicationController
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = Current.user

    if @comment.save
      redirect_to post_path(root_post), notice: "댓글이 작성되었습니다"
    else
      redirect_to post_path(root_post), alert: "댓글 작성에 실패했습니다"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    
    if @comment.user == Current.user
      post = root_post_for_comment(@comment)
      @comment.destroy
      redirect_to post_path(post), notice: "댓글이 삭제되었습니다"
    else
      redirect_to root_path, alert: "권한이 없습니다"
    end
  end

  private

  def set_commentable
    if params[:comment][:commentable_type] == "Post"
      @commentable = Post.find(params[:comment][:commentable_id])
    elsif params[:comment][:commentable_type] == "Comment"
      @commentable = Comment.find(params[:comment][:commentable_id])
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def root_post
    commentable = @commentable
    while commentable.is_a?(Comment)
      commentable = commentable.commentable
    end
    commentable
  end

  def root_post_for_comment(comment)
    commentable = comment.commentable
    while commentable.is_a?(Comment)
      commentable = commentable.commentable
    end
    commentable
  end
end
