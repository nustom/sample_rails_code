class ApplicationController < ActionController::Base
  layout 'guest'
  protect_from_forgery with: :exception
  before_action :set_raven_user_context,
                :set_raven_environment_context

  private

  def set_raven_user_context
    return unless current_user.present?
    Raven.user_context(user_id: current_user.id, email: current_user.email)
  end

  def set_raven_environment_context
    Raven.extra_context(
      staging: Rails.configuration.staging
    )
  end

  def not_authenticated
    flash[:warning] = 'You have to authenticate to access this page.'
    redirect_to login_path
  end

  def run(command)
    output = command.run
    output.each do |k, v|
      instance_variable_set('@' + k.to_s, v)
    end
  end

  def access_denied
    flash[:error] = "You don\'t have permission to perform that action."
    redirect_to root_path
  end

  def rebind(command)
    output = command.rebind
    output.each do |k, v|
      instance_variable_set('@' + k.to_s, v)
    end
  end
end
