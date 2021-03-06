require 'rubygems'
require 'camping'
require 'hpricot'
require 'open-uri'

$LOAD_PATH << File.dirname(__FILE__)
require 'either'
require 'app_base'

APPS_PATH = 'yapps'

Camping.goes :Mohole
AppRegistry.all_in(APPS_PATH)

module Mohole::Controllers
  class Index < R '/'
    def get
      render :index
    end
  end

  class Page < R '/([\w|\.-]+)'
    def get(page_name)
      app = AppRegistry.get(page_name)
      redirect "/#{page_name}/#{app.base}"
    end
  end

  class PageTwo < R '/([\w|\.-]+)/(.*)'
    def get(appName, uri)
      fetching = env["REQUEST_URI"].gsub(/^.*http:\/+/, "http://")
      puts "Fetching #{fetching.inspect}"
      doc = Hpricot(open(fetching))
      AppRegistry.get(appName).rewrite doc, uri
    end
  end
end

module Mohole::Views
  def layout
    html do
      head do
        meta({:name => 'viewport', :content => 'width=320'})
        style({:type=>"text/css"}) { text 'body { font:normal 200% Arial, Helvetica, sans-serif; margin:0; padding:0; }' }
        title { 'Get in my moHole!' }
      end
      body { self << yield }
    end
  end

  def index
    p 'Here are the apps!:'
    ul do
      AppRegistry.all_in(APPS_PATH).each_value do |app|
        li { a app.name, :href => app.name }
      end
    end
  end
end