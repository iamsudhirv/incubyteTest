class SalaryMetricsController < ApplicationController
  def country
    metrics = Employee.country_salary_metrics(params[:country])

    if metrics
      render json: { country_metrics: metrics }
    else
      render json: { error: "No employees found for country #{params[:country]}" }, status: :not_found
    end
  end

  def job_title
    metrics = Employee.job_title_salary_metrics(params[:job_title])

    if metrics
      render json: { job_title_metrics: metrics }
    else
      render json: { error: "No employees found for job title #{params[:job_title]}" }, status: :not_found
    end
  end
end
