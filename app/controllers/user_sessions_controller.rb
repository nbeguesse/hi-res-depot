class UserSessionsController < ApplicationController
  #force_ssl
  before_filter :require_user, :only => [:destroy]

  def debug
    @request = request.session_options
  end


  def create
    @user_session = UserSession.new(params[:user_session])

    session[:return_to] = nil
    if @user_session.save
      if @user_session.record.may_login?
        redirect_to new_image_path
      else
        flash[:error] =  "Sorry, your access has been blocked."
        out = {:errors=>flash[:access_error]}
        @user_session.destroy
        respond_to do |format|
          format.html { redirect_to root_url }
          format.json { render :json=>out.to_json(:root=>"user")}
        end
      end
    else
      flash[:error] = "Incorrect email or password. Please try again."
      out = {:errors=>@user_session.errors.full_messages}
      respond_to do |format|
        format.html { redirect_to login_path }
        format.json { render :json=>out.to_json(:root=>"user")}
      end
    end
  end

  def destroy
    current_user.reset_persistence_token
    current_user_session.destroy
    if params[:redirect]
      redirect_to params[:redirect]
    else
      flash[:notice] = "See you soon!"
      redirect_to root_url
    end
  end

  def show
    redirect_to root_path
  end


end