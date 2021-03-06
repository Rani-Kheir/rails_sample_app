class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers] ## To control who can see content when they are logged in
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  # Comment that ^ to trigger a fail for testing 'admin only delete'

  def index
    #@users = User.all
    #@users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated #for exercise
    #debugger
    ##Chapter 13
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
    #debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # Older create, pre-mailer activation (chapter 11)
      #log_in @user
      #flash[:success] = "Welcome to the Sample App, Hooman!"
      #redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  ## Private methods
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
