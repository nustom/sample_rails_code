class UserSessionsController < ApplicationController
  def create
    @user = login_user(params)
    return login_error unless @user
    redirect_user(@user, params)
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def login_user(params)
    login(params[:email], params[:password])
  end

  def login_error
    flash.now[:alert] = 'Login failed'
    redirect_back(fallback_location: root_path)
  end

  def redirect_user(user, params)
    save_user_timezone(user, params)
    case user.type
    when 'AdminUser'
      redirect_back_or_to(admin_root_path, notice: 'Login successful')
    else
      select_profile(user)
      redirect_back_or_to(root_path, notice: 'Login successful')
    end
  end

  def select_profile(user)
    profile = UserProfileSelector.new(user).run
    session[:current_profile]   = profile[:type]
    session[:profile_entity_id] = profile[:id]
  end

  def save_user_timezone(user, params)
    return unless user.timezone.nil?
    user.update_attributes(timezone: params[:user_timezone])
  end
end
