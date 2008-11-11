ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resources :scripts
  end

  map.resources :scripts

  map.root :controller => 'scripts', :action => 'index'
end
