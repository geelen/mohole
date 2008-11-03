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
    @base_uri = URI.parse(base)
    raise "Need a full http://address/, got #{base.inspect}" if !@base_uri.scheme
  end

  def rewrite doc
    title = doc.at(:title).inner_text

    @rewrite.call doc

    if (title_tag = doc.at(:title))
      title_tag.inner_html = "MoHole! - #{title}"
    elsif (head_tag = doc.at(:head))
      head_tag.inner_html += "<title>MoHole! - #{title}</title>"
    elsif (body_tags = (doc/:body))
      body_tags.prepend("<head><title>MoHole! - #{title}</title></head>")
    end

    (doc/'//a[@href]').each { |a_tag|
      a_tag.raw_attributes['href'] = hack_link(a_tag.attributes['href'], true)
    }

    (doc/'//form[@action]').each { |a_tag|
      a_tag.raw_attributes['action'] = hack_link(a_tag.attributes['action'], true)
    }

    (doc/'//link[@href]').each { |link_tag|
      link_tag.raw_attributes['href'] = hack_link(link_tag.attributes['href'])
    }

    (doc/'//img[@src]').each { |img_tag|
      img_tag.raw_attributes['src'] = hack_link(img_tag.attributes['src'])
    }

    (doc/'//script[@src]').each { |img_tag|
      img_tag.raw_attributes['src'] = hack_link(img_tag.attributes['src'])
    }

    (doc/'//iframe[@src]').each { |iframe_tag|
      iframe_tag.raw_attributes['src'] = hack_link(iframe_tag.attributes['src'])
    }
    doc.to_s.gsub(/<!--.*?-->/, '')
  end

  private

  def hack_link(url, proxy = false)
    case url
    when /^javascript/:
      url
    when /\.jpg/:
      url
    else
      uri = URI.parse(url.strip.gsub(/ /, '%20'))
      result =
              if proxy
                "/#{@name}/#{@base_uri.scheme}://" +
                        if uri.relative?
                          @base_uri.host
                        else
                          puts "Warning! Proxying non-base url #{uri}" if uri.host != @base_uri.host
                          uri.host
                        end + "#{uri.path}"
              else
                if uri.relative?
                  "#{@base_uri.scheme}://#{@base_uri.host}" +
                          if uri =~ /^\// then
                            ""
                          else
                            "/"
                          end
                else
                  ""
                end + "#{uri.to_s}"
              end
      puts "Hacking: #{url.inspect} with proxy: #{proxy} gives: #{result}"
      result
    end
  end
end


