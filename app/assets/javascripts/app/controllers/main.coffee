
#
#   Main controller for the whole application
#

class MainController extends AbstractController
    constructor: (@view) ->
        super @view

    getView:->
        return @view