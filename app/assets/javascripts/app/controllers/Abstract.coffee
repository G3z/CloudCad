#
#   Abstract class for every controller
#
class CC.controllers.Abstract extends Spine.Controller

    constructor: (view) ->
        super()
        @view = view

    getView:->
        return @view;
    