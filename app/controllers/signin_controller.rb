class SigninController < ApplicationController
  def login
    @prefilled_email = params[:e]
    redirect_to root_path if logged_in?
  end

  def crm_login
    begin
      user = LoginCommand::SigninCrmLogin.new(params).run
    rescue Errors::NotFound => e
      return redirect_to login_path, notice: e.message
    rescue Errors::GeneralError => e
      return redirect_to login_path, notice: e.message
    end

    auto_login(user)
    session[:current_profile] = 'student'
    redirect_to root_path
  end
end
