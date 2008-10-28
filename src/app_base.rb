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
  def self.define name, &blk
    builder = AppBuilder.new name
    builder.instance_eval &blk
    register builder.get
    name
  end

  def self.register app
    (@registered_apps ||= {})[app.name] = app
  end

  def self.all_in dir
    Dir[File.join(dir, '**', '*.rb')].each do |file|
      name, f = @files.to_a.detect { |name, f| f == file }
      if name.nil? || File.new(file).mtime != @mtimes[name]
        self.reload(file)
      end
    end
    @registered_apps
  end

  def self.get(name)
    if File.new(@files[name]).mtime != @mtimes[name]
      self.reload(@files[name])
    end
    @registered_apps[name]
  end

  private

  def self.reload(file)
    puts "Loading: #{file}"
    name = AppRegistry.instance_eval(IO.read(file))
    (@files ||= {})[name] = file
    (@mtimes||= {})[name] = File.new(file).mtime
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
      link.raw_attributes['href'] = hack_link(link.attributes['href'], true)
    }

    (doc/'//img[@src]').each { |link|
      link.raw_attributes['src'] = hack_link(link.attributes['src'])
    }
    doc.to_s.gsub(/<!--.*?-->/, '')
  end

  private

  def hack_link(url, proxy = false)
    result =
            if proxy
              "/#{@name}/" + @base.sub(/\/$/, '') + url.sub(/^http:\/\/[^\/]+/, '')
            elsif url =~ /^http[s:]\/\//
              url
            else
              @base.sub(/\/$/, '') + url
            end
#      puts "Hacking: #{url.inspect} with proxy: #{proxy} gives: #{result}"
    result
  end
end


