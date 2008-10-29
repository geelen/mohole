define 'abc_news' do
  base 'http://www.abc.net.au/news/'
  rewrite do |doc|
    (doc/:head).remove
    (doc/:body).prepend(%Q{
<head>
  <meta name='viewport' content='width=320''>
  <style type="text/css">
    body { font:normal 100% Arial, Helvetica, sans-serif; margin:0; padding:0; }
  </style>
</head>
    })
    (doc/'#gN_Nav').remove
    (doc/'#nav').remove
    (doc/:script).remove
    (doc/:iframe).remove
  end
end