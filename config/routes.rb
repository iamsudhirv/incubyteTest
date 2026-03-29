Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :employees do
        member do
          get :salary
        end
      end

      get "salary_metrics/countries/:country", to: "salary_metrics#country"
      get "salary_metrics/job_titles/:job_title", to: "salary_metrics#job_title"
    end
  end
end
