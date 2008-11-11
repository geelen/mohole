require 'open-uri'
require 'hpricot'

class ScriptExecutor
  def initialize
    
  end
  
  def fetch_uri(uri)
    fetching = "http://#{uri}"
    log "Fetching #{fetching.inspect}"
    Hpricot(open(fetching))
  end
  
  def execute(doc, uri, rewrites)
    title = doc.at(:title).inner_text

    rewrite(doc, uri, rewrites)

    inject_title(title)
  end
  
  def inject_title(title)
    if (title_tag = doc.at(:title))
      title_tag.inner_html = "MoHole! - #{title}"
    elsif (head_tag = doc.at(:head))
      head_tag.inner_html += "<title>MoHole! - #{title}</title>"
    elsif (body_tags = (doc/:body))
      body_tags.prepend("<head><title>MoHole! - #{title}</title></head>")
    end
  end
  
  def rewrite(doc, uri, rewrites)
    
  end
  
  def 
end