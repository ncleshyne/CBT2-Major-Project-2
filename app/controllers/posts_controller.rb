class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :owned_post, only: [:edit, :update, :destroy]
  def index
    @posts = Post.all.order('created_at DESC').page params[:page]
    if params[:tag]
    @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.all
    end
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to @post
    else
      flash[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
    end
  end
  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to posts_path
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
  end
  def upvote 
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    respond_to do |format|
    format.html { redirect_to posts_path }
    format.js
    end
  end
  def downvote
    @post = Post.find(params[:id])
    @post.downvote_by current_user
    respond_to do |format|
    format.html { redirect_to posts_path }
    format.js
    end
  end
  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:image, :caption, :all_tags)
  end

  def set_post
    @post = Post.find(params[:id])
  end
  def owned_post
    unless current_user == @post.user
      flash[:alert] = "That post doesn't belong to you!"
      redirect_to root_path
    end
  end
end
