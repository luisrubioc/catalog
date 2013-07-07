class DirectoriesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def new
  end

  def create
    @directory = current_user.directories.build(params[:directory])
    if @directory.save
      flash[:success] = "Directory created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def index
  	@directories = Directory.paginate(page: params[:page])
  end

  def destroy
    @directory.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @directory = current_user.directories.find_by_id(params[:id])
      redirect_to root_url if @directory.nil?
    end
end