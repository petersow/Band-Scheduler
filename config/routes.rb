BandSchedulerBdd::Application.routes.draw do

  get "people/index"
  get "people/new"

  get "roles/index"
  get "roles/new"

  resources :people
  resources :roles
  resources :performances

  resources :events

  match 'scheduler/generate' => 'scheduler#default_generate', :as => 'generate_schedule'
  match 'scheduler/clear' => 'scheduler#clear', :as => 'clear_schedule'
  
  match 'events/:event_id/remove_person/:person_id' => 'events#remove_person', :as => 'event_remove_person'

  root :to => "menu#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
