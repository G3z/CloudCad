class CC.views.draw.MouseButton

    ###
    Represent the Mouse state
    ###

    constructor:->
        @down = false
        @start= {
            x:0
            y:0
        }
        @absoluteDelta= {
            w:0
            h:0
        }
        @delta= {
            w:0
            h:0
        }
        @oldDelta= {
            w:0
            h:0
        }
        @end={
            x:0
            y:0
        }