
#
#   Main controller for the whole application
#

class CC.controllers.Main extends CC.controllers.Abstract

    @stage

    constructor: (view) ->
        super @view

        # Create the stage with the correct rendering
        if Modernizr.webgl
            @stage = new CC.views.draw.Stage3d()
        else
            if Modernizr.canvas
                @stage = new CC.views.draw.Stage3d("canvas")
            else
                @stage = new CC.views.draw.Stage3d("svg")

        @stage.animate()
