class RelationshipsController < ApplicationController
  before_action :logged_in_user

  ## All user have become @user in Listing 14.36, this is because
  ## we need to use the user variable in the partials of _follow
  ## and _unfollow

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
