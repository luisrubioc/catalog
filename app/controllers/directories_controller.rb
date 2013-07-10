class DirectoriesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def show
    @directory = Directory.find(params[:id])
  end

  def new
    @directory = Directory.new
  end

  def create
    @directory = current_user.directories.build(params[:directory])
    if @directory.save
      flash[:success] = t :directory_created
      redirect_to @directory
    else
      render 'new'
    end
  end  

  def index
  	@directories = Directory.paginate(page: params[:page])
  end

  def edit
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