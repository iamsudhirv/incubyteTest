require "test_helper"

class EmployeesApiTest < ActionDispatch::IntegrationTest
  setup do
    Employee.delete_all
    @employee = Employee.create!(
      full_name: "Ada Lovelace",
      job_title: "Backend Engineer",
      country: "India",
      salary: 120_000
    )
  end

  test "lists employees" do
    get "/api/v1/employees"

    assert_response :success
    assert_equal 1, json_response.fetch("employees").length
    assert_equal @employee.id, json_response.dig("employees", 0, "id")
  end

  test "shows an employee" do
    get "/api/v1/employees/#{@employee.id}"

    assert_response :success
    assert_equal @employee.full_name, json_response.fetch("employee").fetch("full_name")
  end

  test "creates an employee" do
    assert_difference("Employee.count", 1) do
      post "/api/v1/employees", params: {
        employee: {
          full_name: "Grace Hopper",
          job_title: "Engineering Manager",
          country: "United States",
          salary: 150_000
        }
      }, as: :json
    end

    assert_response :created
    assert_equal "Grace Hopper", json_response.dig("employee", "full_name")
  end

  test "returns validation errors when creating an invalid employee" do
    post "/api/v1/employees", params: {
      employee: {
        full_name: "",
        job_title: "",
        country: "",
        salary: -1
      }
    }, as: :json

    assert_response :unprocessable_entity
    assert_includes json_response.fetch("errors"), "Full name can't be blank"
    assert_includes json_response.fetch("errors"), "Salary must be greater than or equal to 0"
  end

  test "updates an employee" do
    patch "/api/v1/employees/#{@employee.id}", params: {
      employee: {
        job_title: "Staff Engineer",
        salary: 140_000
      }
    }, as: :json

    assert_response :success
    assert_equal "Staff Engineer", json_response.dig("employee", "job_title")
    assert_equal "140000.0", json_response.dig("employee", "salary")
  end

  test "deletes an employee" do
    assert_difference("Employee.count", -1) do
      delete "/api/v1/employees/#{@employee.id}"
    end

    assert_response :no_content
  end

  test "returns not found for a missing employee" do
    get "/api/v1/employees/0"

    assert_response :not_found
    assert_equal "Employee not found", json_response.fetch("error")
  end
end
