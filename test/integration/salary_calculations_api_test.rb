require "test_helper"

class SalaryCalculationsApiTest < ActionDispatch::IntegrationTest
  test "calculates deductions and net salary for india" do
    employee = Employee.create!(
      full_name: "Ada Lovelace",
      job_title: "Engineer",
      country: "India",
      salary: 100_000
    )

    get "/api/v1/employees/#{employee.id}/salary"

    assert_response :success
    assert_equal "100000.0", json_response.dig("salary", "gross_salary")
    assert_equal "10000.0", json_response.dig("salary", "deductions")
    assert_equal "90000.0", json_response.dig("salary", "net_salary")
    assert_equal "0.1", json_response.dig("salary", "tds_rate")
  end

  test "calculates deductions and net salary for the united states" do
    employee = Employee.create!(
      full_name: "Grace Hopper",
      job_title: "Engineer",
      country: "United States",
      salary: 100_000
    )

    get "/api/v1/employees/#{employee.id}/salary"

    assert_response :success
    assert_equal "12000.0", json_response.dig("salary", "deductions")
    assert_equal "88000.0", json_response.dig("salary", "net_salary")
    assert_equal "0.12", json_response.dig("salary", "tds_rate")
  end

  test "calculates zero deductions for other countries" do
    employee = Employee.create!(
      full_name: "Linus Torvalds",
      job_title: "Engineer",
      country: "Finland",
      salary: 100_000
    )

    get "/api/v1/employees/#{employee.id}/salary"

    assert_response :success
    assert_equal "0.0", json_response.dig("salary", "deductions")
    assert_equal "100000.0", json_response.dig("salary", "net_salary")
    assert_equal "0.0", json_response.dig("salary", "tds_rate")
  end
end
