class CC.views.draw.primitives.Path extends CC.views.draw.primitives.AbstractPrimitives
    @paperPath
    @points
    @segments
    @lastPoint
    @selectedPoint
    @selectedSegment

    constructor:(point,@name)->
        super()
        @points = []
        @segments = []
        @paperPath = new paper.Path()
        @paperPath.strokeColor = 'black'
        @paperPath.fillColor = '#eeeeee'
        @paperPath.closed = true
        @paperPath.strokeWidth = 2
        #@path.strokeCap = 'round';
        @start(point)
    start:(point)=>
        @add(point)

    add:(point)=>
        point.idx = @points.length
        point.father = this
        @points.push(point)
        @paperPath.add(point)
        @update()
                
    move:(el,newPos)=>
        if el instanceof CC.views.draw.primitives.Point
            @movePoint(el,newPos)
        if el instanceof CC.views.draw.primitives.Segment
            @moveSegment(el,newPos)

    movePoint:(point,newPoint)=>
        point.moveTo(newPoint)
        @update()

    point:(selector)->
        unless selector?
            return null
        else if selector == "last"
            return @points[@points.length-1]
        else if selector == "first"
            return @points[0]
        else if selector == "selected"
            return @points[@selectedPoint]
        else if typeof(selector) == "number" && selector < @points.length && selector > -1
            return @points[parseInt(selector)]
    
    pointNear:(point,tollerance)=>
        for i in [0...@segments.length]
            if @paperPath.segments[i].point.isClose(point,tollerance)
                @selectedPoint = i
                return @selectedPoint
        return null

    update:=>
        @lastPoint = @point("last")
        @segments = @paperPath.segments
        paper.view.draw()

    selected:(activate)=>
        unless activate
            @paperPath.selected = false
        else
            @paperPath.selected = true