define 'news.com.au' do
  base "http://www.news.com.au/"
  rewrite do |doc|
    title = doc.at(:title).innerText
    (doc/:head).remove
    (doc/:body).prepend("<head><meta name='viewport' content='width=320''><title>MoHole! - #{title}</head>")
    (doc/'div.skip').remove
    (doc/'div.ad').remove
    (doc/:iframe).remove
    (doc/'#network-bar').remove
    (doc/'#time-date').remove
    (doc/'#nav').remove
    (doc/'#ninnbar').remove
    (doc/'#ticker').remove
  end
end
