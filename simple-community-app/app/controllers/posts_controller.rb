class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @top_level_comments = @post.comments.where(commentable_type: "Post").includes(:user, :comments).order(created_at: :desc).page(params[:comments_page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "게시글이 작성되었습니다"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @post.user == Current.user
      redirect_to posts_path, alert: "권한이 없습니다"
    end
  end

  def update
    unless @post.user == Current.user
      redirect_to posts_path, alert: "권한이 없습니다"
      return
    end

    if @post.update(post_params)
      redirect_to @post, notice: "게시글이 수정되었습니다"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @post.user == Current.user
      redirect_to posts_path, alert: "권한이 없습니다"
      return
    end

    @post.destroy
    redirect_to posts_path, notice: "게시글이 삭제되었습니다"
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
