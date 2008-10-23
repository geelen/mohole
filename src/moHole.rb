# Created by IntelliJ IDEA.
# User: Glen
# Date: 23/10/2008
# Time: 21:21:51
# To change this template use File | Settings | File Templates.

require 'rubygems'
require 'camping'
require 'hpricot'
require 'open-uri'

#require File.join(File.dirname(__FILE__), 'app')

Camping.goes :Mohole

class Left
    def initialize val
        @val = val
    end

    def isLeft
        return true
    end

    def toLeft
        return @val
    end

    def isRight
        return false
    end

    def toRight
        raise "Right on left!"
    end
end

class Right
    def initialize val
        @val = val
    end

    def isLeft
        return false
    end

    def toLeft
        raise "Left on right!"
    end

    def isRight
        return true
    end

    def toRight
        return @val
    end
end

class App
    def self.load(sourceFile)
        hash = check(eval(IO.readlines(sourceFile).join("\n")))
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

    def self.execute(appName)
        filename = File.join("apps", appName + ".rb")
        if File.exists?(filename)
            hash = self.load filename
            doc = Hpricot(open(hash[:url]))
            hash[:replace].call doc
            doc.to_s
        else
            return "No app with name #{appName}"
        end
    end
end

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
            App.execute page_name
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