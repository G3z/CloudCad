define(
    "views/draw/3D/Tool3D"
    ()->
        class CC.views.draw.Tool3D
            @active
            @path
            @stage2d
            constructor:(stage)->
                @stage2d = stage
                @path = stage.path
                @active = false
)