define(
    "views/draw/3D/Tool3D"
    ()->
        class CC.views.draw.Tool3D
            @active
            @path
            @stage3d
            constructor:(@stage3d)->
                @path = @stage3d.activePath
                @active = false
)