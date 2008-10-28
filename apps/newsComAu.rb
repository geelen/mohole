define 'news.com.au' do
  base "http://www.news.com.au/"
  rewrite do |doc|
    title = doc.at(:title).innerText
    (doc/:head).remove
    (doc/:body).prepend(%Q{
<head>
  <meta name='viewport' content='width=320''>
  <title>MoHole! - #{title}</title>
  <style type="text/css">
    body { font:normal 100% Arial, Helvetica, sans-serif; margin:0; padding:0; }
  </style>
</head>})
    (doc/'div.skip').remove
    (doc/'div.ad').remove
    (doc/:iframe).remove
    (doc/'#network-bar').remove
    (doc/'#time-date').remove
    (doc/'#nav').remove
    (doc/'#ninnbar').remove
    (doc/'#ticker').remove
    (doc/'#vxFlashPlayer').remove
    (doc/'.toolbar').remove
    (doc/'.module-header').remove
    (doc/'#title-bar').remove
    (doc/'#content-wrapper').set({:style => ""})
    (doc/'#ad').remove
    (doc/'#skip-advert').remove
    (doc/'#gallery-splash-page').remove
    (doc/'#image-lead'/:img).set({:width => '260', :height => '254'})
  end
end
