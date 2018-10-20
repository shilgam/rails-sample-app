class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  # Before filters

  # Confirms a logged-in user
  def logged_in_user
    return true if logged_in?

    store_location
    flash[:danger] = "Please log in."
    redirect_to login_url
  end
end
