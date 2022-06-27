class PasswordResetsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to(root_path, notice: 'Instructions have been sent to your email.')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    return not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    return not_authenticated if @user.blank?

    if @user.change_password!(user_params[:password])
      redirect_to(root_path, notice: 'Password was successfully updated.')
    else
      render action: 'edit'
    end
  end

  private

  def user_params
    params[:user] || params[:admin_user]
  end
end
