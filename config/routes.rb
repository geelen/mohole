ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resources :scripts
  end

  map.resources :scripts

  map.run_script '/scripts/:id/run/*uri', :controller => 'scripts', :action => 'run'
  map.run_user_script '/users/:user_id/scripts/:id/run/*uri', :controller => 'scripts', :action => 'run'

  map.root :controller => 'scripts', :action => 'index'
end
