class SharedBaseController < ApplicationController
  attr_reader :current_profile, :current_role, :default_fallback_location

  layout :dynamic_layout
  before_action :require_login
  protect_from_forgery with: :exception

  def dynamic_layout
    determine_role
    determine_default_fallback_location

    layout_of_current_role
  end

  def determine_role
    if @current_user.admin?
      @current_role = :admin
      return
    end
    @current_role = session[:current_profile]&.to_sym

    profile_of_current_role
  end

  def determine_default_fallback_location
    case @current_role
    when :admin
      @default_fallback_location = admin_root_path
    when :partner
      @default_fallback_location = partner_root_path
    when :instructor
      @default_fallback_location = trainer_root_path
    when :client_admin
      @default_fallback_location = admin_client_root_path
    when :division_manager
      @default_fallback_location = manager_division_root_path
    end
  end

  private

  def layout_of_current_role
    case current_role
    when :admin
      'admin'
    when :partner
      'partner'
    when :instructor
      'trainer'
    when :client_admin
      'client_admin'
    when :division_manager
      'division_manager'
    end
  end

  def profile_of_current_role
    profile_entity_id = session['profile_entity_id']
    case current_role
    when :partner
      @current_profile = Partnership.find(profile_entity_id)
    when :instructor
      @current_profile = Instructor.find(profile_entity_id)
    when :client_admin
      @current_profile = ClientAdmin.find(profile_entity_id)
    when :division_manager
      @current_profile = DivisionManager.find(profile_entity_id)
    end
  end
end
