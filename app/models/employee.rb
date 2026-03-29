class Employee < ApplicationRecord
  TDS_RATES = {
    "india" => 0.1.to_d,
    "united states" => 0.12.to_d
  }.freeze

  validates :full_name, :job_title, :country, presence: true
  validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def tds_rate
    TDS_RATES.fetch(country.to_s.strip.downcase, 0.to_d)
  end

  def deductions
    salary.to_d * tds_rate
  end

  def net_salary
    salary.to_d - deductions
  end

  def self.country_salary_metrics(country)
    employees = where(country: country)
    return if employees.empty?

    {
      country: country,
      minimum_salary: employees.minimum(:salary),
      maximum_salary: employees.maximum(:salary),
      average_salary: employees.average(:salary).to_d
    }
  end

  def self.job_title_salary_metrics(job_title)
    employees = where(job_title: job_title)
    return if employees.empty?

    {
      job_title: job_title,
      average_salary: employees.average(:salary).to_d
    }
  end
end
