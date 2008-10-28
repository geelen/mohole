define 'abc_news' do
  base 'http://www.abc.net.au/news/'
  rewrite do |doc|
#    (doc/:head).remove
    (doc/'#gN_Nav').remove
    (doc/'#nav').remove
    (doc/:script).remove
    (doc/:iframe).remove
  end
end