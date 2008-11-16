require 'open-uri'
require 'hpricot'

class ScriptExecutor
  LinkHacks = [
          {:proxy => true, :tags => {:href => [:a], :action => [:form]}},
                  {:proxy => false, :tags => {:href => [:link], :src => [:img, :script, :iframe]}}
  ]
  TitlePrefix = 'moHole!'

  def fetch_uri(uri)
    fetching = uri.start_with "http://"
    #todo: fix
    log "Fetching #{fetching.inspect}" rescue nil
    Hpricot(open(fetching))
  end

  def execute(doc, uri, rewrites, name, base_uri)
    title = doc.at(:title).inner_text
    rewrite(doc, uri, rewrites)
    inject_title(doc, title)
    hack_links(doc, uri, name, base_uri)
    doc.to_s.gsub(/<!--.*?-->/, '')
  end

  def inject_title(doc, title)
    if (title_tag = doc.at(:title))
      title_tag.inner_html = "#{TitlePrefix} - #{title}"
    elsif (head_tag = doc.at(:head))
      head_tag.inner_html += "<title>#{TitlePrefix} - #{title}</title>"
    elsif (html_tags = (doc/:html))
      html_tags.prepend("<head><title>#{TitlePrefix} - #{title}</title></head>")
    end
  end

  def rewrite(doc, uri, rewrites)
    rewrites.each { |rule|
      rule['remove'].each { |t| search(doc, t) { |elems| elems.remove } }
      rule['prepend'].each { |prep| (doc/prep['at']).prepend(prep['insert'].to_s) }
      rule['inject'].each { |prep|
        injections = Hash[*prep.map { |k, v| [k.to_s, v.to_s] }.delete_if { |k, _| k == 'at' }.compact.flatten]
        self.search(doc, prep['at']) { |elems|
          elems.set(injections)
        }
      }
    }
  end

  def hack_links(doc, uri, name, base_uri)
    LinkHacks.each { |hack|
      hack[:tags].each { |attr, tags|
        tags.each { |tag|
          (doc/"//#{tag}[@#{attr}]").each { |a_tag|
            a_tag.raw_attributes[attr.to_s] = hack_link(uri, a_tag.attributes[attr.to_s], name, base_uri, hack[:proxy])
          }
        }
      }
    }
  end

  def hack_link(request_uri, url, name, base_uri, proxy = false)
    case url
    when /^javascript/, /^mailto/:
      url
      # when /\.jpg/, /\.png/:
      # url
    else
      uri = URI.parse(url.strip.gsub(/ /, '%20'))
      result = (proxy ? "/#{name}/" : "") + (uri.relative? ? absolutify(request_uri, uri) : "") + uri.to_s
#      puts "Hacking: #{url.inspect} with proxy: #{proxy} gives: #{result}"
      result
    end
  end

  def absolutify(current_uri, uri)
    req_uri = URI.parse(current_uri)
    "#{req_uri.scheme}://#{req_uri.host}#{uri.path =~ /^\// ? "" : req_uri.path.match(/(.*\/)[^\/]+/)[1]}"
  end

  def search(doc, objs)
    if objs.is_a? Array then
      objs
    else
      [objs]
    end.each { |obj|
      if obj.is_a? Hash
        str = obj['search']
        indices = obj['at_indices']
        str.split('/').inject(doc) { |d, s| d/s.to_s }.values_at(*indices).compact.each { |elem| yield elem.search("*") }
      else
        yield obj.split('/').inject(doc) { |d, s| d/s.to_s }
      end
    }
  end
end
