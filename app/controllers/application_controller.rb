class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # FIXME: here should be a real object of User returned
  def current_user
    'current_user'
  end
end
