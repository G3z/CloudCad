#
#   Main controller for the whole application
#

S.export(
    "controllers/Main",
    ["controllers/Abstract", "views/draw/3D/Stage3d", "views/Layout"],
    (Abstract, Stage3d, Layout)->
        class Main extends Abstract
            
            @stage3d
            @stage2d

            constructor: (view) ->
                super @view

                # Create the stage with the correct rendering
                @stage3d = Stage3d 
                @stage3d.animate()

                #@stage2d = new CC.views.draw.Stage2d()
                
                # Initialize backbone routes
                #Backbone.history.start({
                #    pushState: true
                #})

            to3d: =>
                return

            to2d: =>
                return

        # Singleton
        return new Main()
)
