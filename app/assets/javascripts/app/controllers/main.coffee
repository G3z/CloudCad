
#
#   Main controller for the whole application
#

class MainController extends CC.AbstractController
    constructor: (@view) ->
        super @view

    getView:->
        return @view