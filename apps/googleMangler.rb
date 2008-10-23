# Created by IntelliJ IDEA.
# User: Glen
# Date: 23/10/2008
# Time: 21:36:51
# To change this template use File | Settings | File Templates.

{
        :url => "http://www.google.com/",
        :replace => proc { |doc|
            (doc/:img).remove
        }
}