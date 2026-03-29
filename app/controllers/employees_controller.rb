class EmployeesController < ApplicationController
  def index
    render json: { employees: Employee.order(:id).map { |employee| employee_payload(employee) } }
  end

  def show
    render json: { employee: employee_payload(employee) }
  end

  def create
    employee = Employee.new(employee_params)

    if employee.save
      render json: { employee: employee_payload(employee) }, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if employee.update(employee_params)
      render json: { employee: employee_payload(employee) }
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    employee.destroy!
    head :no_content
  end

  def salary
    render json: {
      salary: {
        gross_salary: employee.salary,
        tds_rate: employee.tds_rate,
        deductions: employee.deductions,
        net_salary: employee.net_salary
      }
    }
  end

  private

  def employee
    @employee ||= Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:full_name, :job_title, :country, :salary)
  end

  def employee_payload(employee)
    {
      id: employee.id,
      full_name: employee.full_name,
      job_title: employee.job_title,
      country: employee.country,
      salary: employee.salary
    }
  end
end
