S.define(
    "views/draw/2D/Tool2D"
    ()->
        class Tool2D
            
            @active
            @path
            @stage2d

            constructor:(stage)->
                @stage2d = stage
                @path = stage.path
                @active = false
