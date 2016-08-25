class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :all 
  include Authentication

  helper_method :secure?
  def secure?
    Rails.env.production?
  end
end
