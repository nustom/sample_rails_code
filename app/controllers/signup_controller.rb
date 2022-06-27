class SignupController < ApplicationController
  layout 'standalone'

  def index
    @signup = Signup::SignupIndexFacade.new(params)
    return redirect_home if @signup.enrol_disabled?
    redirect_to learner_payment_path(course_id: @signup.course.id) if logged_in?
  end

  def check_email_availability
    available = EmailAvailableService.new(params[:e]).run
    render json: { available: available }
  end

  def create
    @signup = Signup::SignupCreateFacade.new(params)
    return after_signup_create if @signup.create
    render :index
  rescue Errors::Validation => err
    flash.now[:alert] = err.message
    render :index
  end

  private

  def after_signup_create
    auto_login(@signup.user)
    session[:current_profile] = 'student'
    return redirect_to learner_root_path if params[:course_id].blank?
    redirect_to learner_payment_path(course_id: params[:course_id])
  end

  def redirect_home
    flash[:alert] = I18n.t('learner.course.enrolment_disabled')
    return redirect_to learner_root_path if logged_in?
    redirect_to root_path
  end
end
