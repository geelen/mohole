ActionController::Routing::Routes.draw do |map|
  map.resources :scripts
  map.root :controller => 'scripts', :action => :index
end
