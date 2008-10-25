
# DSL for defining apps
class AppBuilder
  def initialize name
    @name = name
  end
  
  def rewrite &blk
    @rewrite = blk
  end
    
  def base url
    @base = url
  end
  
  def get
    AppBase.new(@name, @base, @rewrite)
  end
end

class AppRegistry
  def self.all
    @registered_apps
  end
  
  def self.define name, &blk
    builder = AppBuilder.new name
    builder.instance_eval &blk
    register builder.get
  end
  
  def self.register app
    (@registered_apps ||= {})[app.name] = app
  end
  
  def self.load_directory dir
    Dir[File.join(dir, '**', '*.rb')].each do |file|
      puts "Loading: #{file}"
      AppRegistry.instance_eval IO.read(file)
    end
  end
end

class AppBase
  attr_reader :base, :name
    
  def initialize name, base, rewrite
    @name = name
    @base = base
    @rewrite = rewrite
  end
  
  def rewrite doc
    @rewrite.call doc
        
    (doc/'//a[@href]').each { |link| 
      link.attributes['href'] = hack_link(link.attributes['href'], true) 
    }

    (doc/'//img[@src]').each { |link| 
      link.attributes['src'] = hack_link(link.attributes['src']) 
    }
    doc.to_s.gsub(/<!--.*?-->/, '')
  end
  
  private
  
  def hack_link(url, proxy = false)
      if proxy
          "/#{@name}/" + @base.sub(/\/$/, '') + url.sub(/^http:\/\/[^\/]+/, '')
      elsif url =~ /^http:\/\//
          url
      else
          @base.sub(/\/$/, '') + url
      end
  end
end


