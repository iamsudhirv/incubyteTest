# Incubyte Salary Management Kata

API-only Rails application for managing employees, calculating salary deductions, and exposing salary metrics.

## Tech Stack

- Ruby 3.4.1
- Rails 8 API-only application
- SQLite for development, test, and production persistence
- Minitest for automated tests

## Features

- Employee CRUD endpoints
- Salary calculation endpoint by employee ID
- Salary metrics by country
- Salary metrics by job title
- SQLite-backed persistence

## Data Model

Each employee record stores:

- `full_name`
- `job_title`
- `country`
- `salary`

Validation rules:

- all fields are required
- `salary` must be greater than or equal to `0`

## Salary Rules

- India: `10%` TDS
- United States: `12%` TDS
- All other countries: `0%` deductions

## Setup

1. Install dependencies:

   ```bash
   bundle install
   ```

2. Create and migrate the database:

   ```bash
   bin/rails db:prepare
   ```

3. Start the API server:

   ```bash
   bin/rails server
   ```

The app will be available at `http://localhost:3000`.

## Running Tests

Run the full test suite with:

```bash
bin/rails test
```

## API Endpoints

### Employees

- `GET /employees`
- `GET /employees/:id`
- `POST /employees`
- `PATCH /employees/:id`
- `DELETE /employees/:id`

Create request body:

```json
{
  "employee": {
    "full_name": "Ada Lovelace",
    "job_title": "Backend Engineer",
    "country": "India",
    "salary": 120000
  }
}
```

Successful employee responses are shaped like:

```json
{
  "employee": {
    "id": 1,
    "full_name": "Ada Lovelace",
    "job_title": "Backend Engineer",
    "country": "India",
    "salary": "120000.0"
  }
}
```

Validation failures return:

```json
{
  "errors": [
    "Full name can't be blank",
    "Salary must be greater than or equal to 0"
  ]
}
```

### Salary Calculation

- `GET /employees/:id/salary`

Example response:

```json
{
  "salary": {
    "gross_salary": "120000.0",
    "tds_rate": "0.1",
    "deductions": "12000.0",
    "net_salary": "108000.0"
  }
}
```

### Salary Metrics

By country:

- `GET /salary_metrics/countries/:country`

Example response:

```json
{
  "country_metrics": {
    "country": "India",
    "minimum_salary": "100000.0",
    "maximum_salary": "130000.0",
    "average_salary": "115000.0"
  }
}
```

By job title:

- `GET /salary_metrics/job_titles/:job_title`

Example response:

```json
{
  "job_title_metrics": {
    "job_title": "Backend Engineer",
    "average_salary": "115000.0"
  }
}
```

If no matching records exist, the API returns `404 Not Found`.

## Design Notes

- Business rules for deductions live on the `Employee` model to keep the controller layer thin.
- Salary metric queries are implemented as model class methods to keep aggregation logic close to persistence.
- Error responses are JSON-first to match the API-only app design.

## TDD Approach

The implementation was driven with tests first:

- model tests for validations and salary deduction rules
- request/integration tests for employee CRUD
- request/integration tests for salary calculation
- request/integration tests for salary metrics and missing-record behavior

## Implementation Details

AI was used intentionally during the exercise to speed up delivery while keeping the code reviewable and small:

- used AI assistance to inspect the Rails skeleton quickly and identify the minimum changes required
- used AI assistance to draft the test suite structure for CRUD, salary calculation, and salary metrics
- used AI assistance to scaffold controller/model code and then refined it against failing tests
- used AI assistance to draft this README and document the implementation clearly

Rationale:

- move faster on scaffolding and repetitive setup
- spend more time verifying behavior with tests
- keep the final codebase small, readable, and production-oriented
