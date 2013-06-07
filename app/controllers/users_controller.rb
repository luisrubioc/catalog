class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy]
  before_filter :signed_in_user_filter, only: [:new, :create]
  before_filter :correct_user,          only: [:edit, :update]
  before_filter :admin_user,            only: :destroy
  before_filter :avoid_destroy_myself,  only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t :welcome
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    def signed_in_user_filter
      redirect_to root_path, notice: "Already logged in" if signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def avoid_destroy_myself
      @user = User.find(params[:id])
      redirect_to users_path, :notice => "You can not destroy yourself" unless !current_user?(@user)
    end
end