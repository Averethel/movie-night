class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?
  before_filter :reset_session

  def current_user
    u = nil
    if !!session[:user_id]
      begin
        u = User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        session[:user_id] = nil
      end
    end
    u
  end

  def logged_in?
    !!current_user
  end

private

  def reset_session
    session[:movie_step] = nil
  end
end
