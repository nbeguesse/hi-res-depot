class UsersController < ApplicationController
  #force_ssl

  before_filter :require_user, :only => [:edit, :update]

  def index
    redirect_to :action=>"new"
  end

  def edit
    @user = current_user
    @active_link = "edit_account"
  end

  def update
    
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:notice] = "Updated!"
      redirect_to root_url
    else
      flash[:error] = @user.errors.full_messages.first
      render :edit
    end
  end

  def new
    @user = User.new
    @active_link = "new_account"
  end


  def create
    @user = User.new(user_params)
    if @user.save
        @user_session = UserSession.new(:email=>params[:user][:email], :password=>params[:user][:password])
        @user_session.save #i.e. log them in

        redirect_to root_url
    else

        flash[:error] = "-- " + @user.errors.full_messages.join('<br/> -- ')
        render :new

    end
  end


  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:email, :name, :password)
  end

end
