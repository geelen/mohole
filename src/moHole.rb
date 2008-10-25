# Created by IntelliJ IDEA.
# User: Glen
# Date: 23/10/2008
# Time: 21:21:51
# To change this template use File | Settings | File Templates.

require 'rubygems'
require 'camping'
require 'hpricot'
require 'open-uri'

$LOAD_PATH << File.dirname(__FILE__)
require 'either'
require 'app_base'

Camping.goes :Mohole
AppRegistry.load_directory 'apps'

module Mohole::Controllers
  class Index < R '/'
      def get
          render :index
      end
  end

  class Page < R '/([\w|\.]+)'
      def get(page_name)
        app = AppRegistry.all[page_name]
        redirect "/#{page_name}/#{app.base}"
      end
  end

  class PageTwo < R '/([\w|\.]+)/(.*)'
      def get(page_name, two)
          doc = Hpricot(open(uri.gsub(/http:\/+/, "http://")))
          AppRegistry.all[appName].rewrite doc
      end
  end
end

module Mohole::Views
    def layout
        html do
            title { 'Get in my moHole!' }
            body { self << yield }
        end
    end

    def index
        p 'Here are the apps!:'
        ul do
          AppRegistry.all.each_value do |app|
            li { a app.name, :href => app.name }
          end
        end
    end
end