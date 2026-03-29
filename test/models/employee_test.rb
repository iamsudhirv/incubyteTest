require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "is invalid without required attributes" do
    employee = Employee.new

    assert_not employee.valid?
    assert_includes employee.errors[:full_name], "can't be blank"
    assert_includes employee.errors[:job_title], "can't be blank"
    assert_includes employee.errors[:country], "can't be blank"
    assert_includes employee.errors[:salary], "can't be blank"
  end

  test "salary must be non negative" do
    employee = Employee.new(
      full_name: "Ada Lovelace",
      job_title: "Engineer",
      country: "India",
      salary: -10
    )

    assert_not employee.valid?
    assert_includes employee.errors[:salary], "must be greater than or equal to 0"
  end

  test "returns india deduction details" do
    employee = Employee.new(
      full_name: "Ada Lovelace",
      job_title: "Engineer",
      country: "India",
      salary: 1000
    )

    assert_equal 0.1.to_d, employee.tds_rate
    assert_equal 100.to_d, employee.deductions
    assert_equal 900.to_d, employee.net_salary
  end

  test "returns united states deduction details" do
    employee = Employee.new(
      full_name: "Grace Hopper",
      job_title: "Engineer",
      country: "United States",
      salary: 1000
    )

    assert_equal 0.12.to_d, employee.tds_rate
    assert_equal 120.to_d, employee.deductions
    assert_equal 880.to_d, employee.net_salary
  end

  test "returns zero deductions for other countries" do
    employee = Employee.new(
      full_name: "Linus Torvalds",
      job_title: "Engineer",
      country: "Finland",
      salary: 1000
    )

    assert_equal 0.to_d, employee.tds_rate
    assert_equal 0.to_d, employee.deductions
    assert_equal 1000.to_d, employee.net_salary
  end
end
