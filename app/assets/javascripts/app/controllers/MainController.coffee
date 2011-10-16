
#
#   Main controller for the whole application
#

class CC.controllers.Main extends CC.controllers.Abstract

    constructor: (view) ->
        super @view

        # Create the stage
        stage = new CC.views.draw.Stage3d()
        stage.animate()
