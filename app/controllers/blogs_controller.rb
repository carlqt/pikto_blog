class BlogsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]
  before_action :set_blog, only: [:show, :edit, :update, :destroy, :update_blog_status]

  # GET /blogs
  # GET /blogs.json
  def index
    if user_signed_in?
      if current_user.is_admin? || current_user.is_editor?
        @blogs = Blog.all
      else
        @blogs = current_user.blogs
      end
    else
      @blogs = Blog.where(:status=>'published')
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @comment = @blog.comments.new
    @all_comments = Comment.all
    unless current_user.is_owner?( @blog )
      respond_to do |format|
        format.html { redirect_to '/', notice: 'You are not allowed to view this blog!' }
      end
    else
      unless @blog.is_publish? || !current_user.is_editor?
        respond_to do |format|
          format.html { redirect_to '/', notice: 'You are not allowed to view this blog!' }
        end
      end
    end
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    if current_user.is_owner?( @blog )
      respond_to do |format|
        if @blog.update(blog_params)
          format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
          format.json { render :show, status: :ok, location: @blog }
        else
          format.html { render :edit }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def rename
    @blog = Blog.find(params[:id])
    respond_to do |format|
      if @blog.update_attribute(:title, sanitize(params[:title]))
        format.json { render json: {status: 200}}
      else
        format.json { render json: {status: 500}}
      end
    end
  end

  def destroy_multiple
    failed = []
    @delete_ids = params[:ids]
    @delete_ids.each do |id|
      unless Blog.find(id).destroy
        failed << id
      end
    end

    respond_to do |format|
      if failed.empty?
        format.js { render js: 'alert("Successful!");' }
      else
        format.js { render js: "alert('#{pluralize(failed.count, "blogs")} were not deleted successfully')" }
      end
    end
  end

  def update_blog_status
    # Does the user have permission to update the blog status?
    if current_user.is_owner?( @blog )
      respond_to do |format|
        if @blog.update(blog_params)
          format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
          format.json { render :show, status: :ok, location: @blog }
        else
          format.html { render :edit }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def search
    @blogs = Blog.where(search_params)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :content, :status, :users_id)
    end

  def search_params
      params.require(:blog).permit(:title, :status)
    end
end
