require "test_helper"

class SalaryMetricsApiTest < ActionDispatch::IntegrationTest
  setup do
    Employee.delete_all
    Employee.create!(
      full_name: "Ada Lovelace",
      job_title: "Backend Engineer",
      country: "India",
      salary: 100_000
    )
    Employee.create!(
      full_name: "Grace Hopper",
      job_title: "Backend Engineer",
      country: "India",
      salary: 130_000
    )
    Employee.create!(
      full_name: "Margaret Hamilton",
      job_title: "Engineering Manager",
      country: "United States",
      salary: 180_000
    )
  end

  test "returns min max and average salary by country" do
    get "/api/v1/salary_metrics/countries/India"

    assert_response :success
    assert_equal "India", json_response.dig("country_metrics", "country")
    assert_equal "100000.0", json_response.dig("country_metrics", "minimum_salary")
    assert_equal "130000.0", json_response.dig("country_metrics", "maximum_salary")
    assert_equal "115000.0", json_response.dig("country_metrics", "average_salary")
  end

  test "returns average salary by job title" do
    get "/api/v1/salary_metrics/job_titles/Backend%20Engineer"

    assert_response :success
    assert_equal "Backend Engineer", json_response.dig("job_title_metrics", "job_title")
    assert_equal "115000.0", json_response.dig("job_title_metrics", "average_salary")
  end

  test "returns not found when no employees match a metric query" do
    get "/api/v1/salary_metrics/countries/Brazil"

    assert_response :not_found
    assert_equal "No employees found for country Brazil", json_response.fetch("error")
  end
end
