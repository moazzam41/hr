class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

protect_from_forgery with: :null_session

  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    else
      super
    end
  end



  def require_manager_login
    if user_signed_in?
      unless current_user.manager?
        respond_to do |format|
          format.html {redirect_to root_path, alert: "You are not authorised to access this page."}
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to root_path, alert: "You must login."}
      end
    end
  end



  
  include Pundit
  protect_from_forgery with: :exception
  before_action :set_user

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_user
    @user = current_user
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :name, :avatar])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform that action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || root_path
  end
  
end
