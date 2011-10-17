class CC.views.draw.Edge extends CC.views.draw.DisplayObject

    ###
    This class represent an edge
    ###

    # the start point #
    @start

    # the end point (instance of CC.views.draw.Point) #
    @end

    contructor: (start, end)->
        super()
        @start = start
        @end = end