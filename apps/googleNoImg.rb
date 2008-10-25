define 'googleNoImg' do
  base "http://www.google.com/"
  rewrite do |doc|
    (doc/:img).remove
  end
end
