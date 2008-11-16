ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resources :scripts
  end

  map.resources :scripts
  
  map.run_script '/scripts/:id/*uri', :controller => 'scripts', :action => 'run'

  map.root :controller => 'scripts', :action => 'index'
end
