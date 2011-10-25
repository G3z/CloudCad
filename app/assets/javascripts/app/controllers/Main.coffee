
#
#   Main controller for the whole application
#

class CC.controllers.Main extends CC.controllers.Abstract

    @stage3d
    @stage2d

    constructor: (view) ->
        super @view
        ###
        # Create the stage with the correct rendering
        if Modernizr.webgl
            @stage3d = new CC.views.draw.Stage3d()
        else
            if Modernizr.canvas
                @stage3d = new CC.views.draw.Stage3d("canvas")
            else
                @stage3d = new CC.views.draw.Stage3d("svg")

        @stage3d.animate()
        ###
        @stage2d = new CC.views.draw.Stage2d()

        # Create the toolbar
        tb = new CC.views.gui.Toolbar("Hello world")

    to3d:=>
        return
    to2d:=>
        return
