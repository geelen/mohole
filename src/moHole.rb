# Created by IntelliJ IDEA.
# User: Glen
# Date: 23/10/2008
# Time: 21:21:51
# To change this template use File | Settings | File Templates.

require 'rubygems'
require 'camping'
require 'hpricot'
require 'open-uri'

require File.join(File.dirname(__FILE__), 'either')

class App
    def self.getBaseUrl(appName)
        hash = self.load appName
        hash[:url]
    end

    def self.execute(appName, uri)
        hash = self.load appName
        doc = Hpricot(open(uri.gsub(/http:\/+/, "http://")))
        hash[:replace].call doc
        (doc/'//a[@href]').each { |link| link.attributes['href'] = "/#{appName}/" + self.getBaseUrl(appName).sub(/\/$/,'') + link.attributes['href'] }
        (doc/'//img[@src]').each { |link|
            link.attributes['src'] = self.getBaseUrl(appName).sub(/\/$/,'') + link.attributes['src'] unless link.attributes['src'] =~ /^http:\/\// }
        doc.to_s.gsub(/<!--.*-->/,'')
    end

    def self.load(appName)
        filename = File.join("apps", appName + ".rb")
        if !File.exists?(filename)
            raise "No app with name #{appName}"
        end
        hash = check(eval(IO.readlines(filename).join("\n")))
        raise hash.toRight + " - FAIL. Need a hash as the only element. Must have be {:url => String, :replace => Proc}" if hash.isRight
        hash.toLeft
    end

    def self.check(hash)
        if !hash.is_a? Hash
            Right.new("hash is not a hash!")
        elsif !hash[:url].is_a? String
            Right.new("hash[:url] is not a String!")
        elsif !hash[:replace].is_a? Proc
            Right.new("hash[:replace] is not a Proc!")
        else
            Left.new(hash)
        end
    end
end

Camping.goes :Mohole

module Mohole::Controllers

    # The root slash shows the `index' view.
    class Index < R '/'
        def get
            render :index
        end
    end

    # Any other page name gets sent to the view
    # of the same name.
    #
    #   /index -> Views#index
    #   /sample -> Views#sample
    #
    class Page < R '/(\w+)'
        def get(page_name)
            redirect "/#{page_name}/#{App.getBaseUrl page_name}"
        end
    end

    class PageTwo < R '/(\w+)/(.*)'
        def get(page_name, two)
            App.execute page_name, two
        end
    end
end

module Mohole::Views

    # If you have a `layout' method like this, it
    # will wrap the HTML in the other methods.  The
    # `self << yield' is where the HTML is inserted.
    def layout
        html do
            title { 'Get in my moHole!' }
            body { self << yield }
        end
    end

    # The `index' view.  Inside your views, you express
    # the HTML in Ruby.  See http://code.whytheluckystiff.net/markaby/.
    def index
        p 'Here at the apps!:'
        ul do
            Dir.glob(File.join('apps', '*')) { |file|
                appName = File.basename(file, '.rb')
                li { a file, :href => appName }
            }
        end
    end
end