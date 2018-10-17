class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end

  private

  # Before filters

  # Confirms a logged-in user
  def logged_in_user
    return true if logged_in?

    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end
end
