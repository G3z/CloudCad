#
#   Main controller for the whole application
#

S.export(
    "controllers/Main",
    ["controllers/Abstract", "views/Layout"],
    (Abstract, Layout)->
        class Main extends Abstract
            
            tagName: "div"
            className: "main_container"

            @stage2d

            constructor: (options) ->
                super(options)

                #@stage2d = new CC.views.draw.Stage2d()
                
                # Initialize backbone routes
                #Backbone.history.start({
                #    pushState: true
                #})
                
                @addChild(Layout)
                $(document.body).append(@el)

            to3d: =>
                return

            to2d: =>
                return

        # Singleton
        new Main()
)
