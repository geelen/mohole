# Created by IntelliJ IDEA.
# User: Glen
# Date: 23/10/2008
# Time: 21:36:51
# To change this template use File | Settings | File Templates.

{
        :url => "http://www.news.com.au/",
        :replace => proc { |doc|
            (doc/:head).remove
            (doc/:body).prepend('<head><meta name="viewport" content="width=320"> </head>')
            (doc/'div.skip').remove
            (doc/'div.ad').remove
            (doc/:iframe).remove
            (doc/'#network-bar').remove
            (doc/'#time-date').remove
            (doc/'#nav').remove
            (doc/'#ninnbar').remove
            (doc/'#ticker').remove
            #can't do this last one :(
            #doc.each_child { |elem| elem.remove if elem.comment? }
        }
}