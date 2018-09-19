module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies[:user_id] = {
      value: user.id,
      expires: 1.years.from_now.utc
    }
    cookies[:remember_token] = {
      value: user.remember_token,
      expires: 1.years.from_now.utc
    }
  end

  # Returns the current logged-in user (if any)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies[:user_id]
      user = User.find_by(id: cookies[:user_id])

      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
