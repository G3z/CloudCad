#
#   Main controller for the whole application
#

define(
    "controllers/Main",
    ["controllers/Abstract", "views/draw/3D/Stage3d", "views/gui/MainToolbar"],
    (Abstract, Stage3d, MainToolbar)->
        class CC.controllers.Main extends Abstract

            @stage3d
            @stage2d

            constructor: (view) ->
                super @view

                # Create the stage with the correct rendering
                if Modernizr.webgl
                    @stage3d = new Stage3d()
                else
                    if Modernizr.canvas
                        @stage3d = new Stage3d("canvas")
                    else
                        @stage3d = new Stage3d("svg")

                @stage3d.animate()

                #@stage2d = new CC.views.draw.Stage2d()

                # Create the toolbar
                tb = new MainToolbar()

            to3d:=>
                return

            to2d:=>
                return
        
)
