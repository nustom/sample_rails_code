module ApplicationHelper
  def active(path)
    'active' if current_page?(path)
  end

  def navbar_context_login
    if logged_in?
      link_to('Logout', logout_path, method: :post, id: 'logout-link')
    else
      link_to('Login', login_path)
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def icon_correct(correct)
    if correct == true
      'ok'
    else
      'remove'
    end
  end

  def render_content
    if @simple_content.assessment?
      render 'assessment_content'
    else
      render 'learning_content'
    end
  end

  def flash_css_class(flash_level)
    case flash_level
    when 'warning', 'info'
      flash_level
    when 'notice'
      'info'
    when 'alert'
      'warning'
    when 'error'
      'danger'
    when 'success'
      'success'
    else
      'info'
    end
  end
end
