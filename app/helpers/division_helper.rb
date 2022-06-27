module DivisionHelper
  def current_division
    Division.find(session[:current_division_id]) if session[:current_division_id].present?
  end
end
