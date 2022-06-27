class StaticController < ApplicationController
  def homepage
    @courses = PublicCourseService.get_courses
    return unless logged_in?
    return redirect_to admin_root_path if @current_user.admin?
    redirect_to(redirect_path)
  end

  def redirect_path
    case session[:current_profile]
    when 'partner'
      partner_root_path
    when 'instructor'
      trainer_root_path
    when 'student'
      learner_root_path
    when 'client_admin'
      admin_client_root_path
    when 'division_manager'
      manager_division_root_path
    end
  end
end
