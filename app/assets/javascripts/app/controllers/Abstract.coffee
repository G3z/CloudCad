
#
#   Abstract class for every controller
#
class CC.controllers.Abstract

    constructor: (view) ->
        @view = view

    getView:->
        return @view;
    