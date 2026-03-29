class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_employee_not_found

  private

  def render_employee_not_found
    render json: { error: "Employee not found" }, status: :not_found
  end
end
