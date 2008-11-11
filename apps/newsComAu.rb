define 'news.com.au' do
  base "http://www.news.com.au/"
  rewrite do |doc|
    (doc/:head).remove
    (doc/:body).prepend(%Q{
<head>
  <meta name='viewport' content='width=320'>
  <style type="text/css">
    body { font:normal 100% Arial, Helvetica, sans-serif; margin:0; padding:5px; }
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
    (doc/'#NewsVisualiser').remove
    (doc/'#gallery-splash-page').remove
    (doc/'#news-weather').remove
    (doc/'.sponsored-feature').remove
    (doc/'#around-australia-all').remove
    (doc/'#module-overview-horoscopes').remove
    (doc/'.ad300x250').remove
    (doc/'#image-lead'/:img).set({:width => '260', :height => '254'})
    [(doc/'.thumbnail'), (doc/'.story-block'/:img)].each { |e| e.set({:style => "float: right;"}) }
#    (doc/:img).each { |img_tag|
#      if (img_tag.attributes['width'].to_i > 320)
#        img_tag.raw_attributes.delete('height')
#        img_tag.raw_attributes['width'] = '320'
#      end
#    }
  end
end