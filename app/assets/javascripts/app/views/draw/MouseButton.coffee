class CC.views.draw.MouseButton

    ###
    Represent the Mouse state
    ###

    constructor:->
        @down = false
        @click = {
            start: {
                x:0
                y:0
            }
            currentPos: {
                x:0
                y:0
            }
            delta: {
                w:0
                h:0
            }
            oldDelta: {
                w:0
                h:0
            }
        }