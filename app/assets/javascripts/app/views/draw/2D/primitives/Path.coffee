class CC.views.draw.primitives.Path extends CC.views.draw.primitives.AbstractPrimitives
    @paperPath
    @points
    @segments
    @lastPoint
    @selectedPoint
    @selectedSegment

    constructor:(point,name,paperPath)->
        super()
        @points = []
        @segments = []
        if paperPath? && paperPath instanceof paper.Path
            @paperPath = paperPath
            @paperPath.ccObject = this
            for segment in @paperPath.segments
                pathPoint = segment.point
                pathPoint=@arrayToPoint([pathPoint.x,pathPoint.y])
                pathPoint.idx = @points.length
                pathPoint.ccObject = this
                @points.push(pathPoint)
        else
            @paperPath = new paper.Path() 
        @paperPath.strokeColor = 'blue'
        @paperPath.fillColor = '#eeeeee'
        @paperPath.closed = true
        @paperPath.strokeWidth = 2
        @paperPath.ccObject = this
        if name?
            @name = name
            @paperPath.name = @name
        #@path.strokeCap = 'round';
        if point? && @arrayToPoint(point)
            @start(point)
    
    update:=>
        @lastPoint = @point("last")
        @segments = @paperPath.segments
        paper.view.draw()

    start:(point)=>
        if @arrayToPoint(point)
            @add(point)

    add:(point)=>
        if @arrayToPoint(point)
            point.idx = @points.length
            point.father = this
            @points.push(point)
            @paperPath.add(point)
            @update()

    insert:(idx,point)=>
        #debugger
        split = idx
        idx++

        if @arrayToPoint(point)
            point.father = this
            point.idx = idx
            points_before = @points[0..split]
            points_before.push(point)
            points_after = @points[idx..@points.length-1]
            @points = points_before.concat(points_after)
            @paperPath.insert(idx,point)
            @rearrangePoints()
            @update()

    remove:(el)=>
        if el instanceof CC.views.draw.primitives.Point2D
            @removePoint(el)
        else if el instanceof CC.views.draw.primitives.Segment
            @removeSegment(el)

    removePoint:(point)=>
        @points.remove(point) if point in @points
        @paperPath.removeSegment(point.idx)
        @rearrangePoints()

    move:(el,newPos)=>
        if el instanceof CC.views.draw.primitives.Point2D
            @movePoint(el,newPos)
        else if el instanceof CC.views.draw.primitives.Segment
            @moveSegment(el,newPos)

    movePoint:(point,newPoint)=>
        point.moveTo(newPoint)
        @update()

    moveSegment:(el,newPos)=>

    point:(selector)=>
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
    
    segmentNear:(point,tollerance)=>
        #debugger
        nearPoint = @paperPath.getNearestPoint(new paper.Point(point.x,point.y))
        circle = new paper.Path.Circle(nearPoint, 3);
        @update()
        if nearPoint.isClose(point,tollerance)
            for segment in @paperPath.segments
                start = segment.point
                if segment.index < @paperPath.segments.length
                    end = segment.next.point
                else
                    end = @paperPath.segments[0].point
                crossproduct = (nearPoint.y - start.y) * (end.x - start.x) - (nearPoint.x - start.x) * (end.y - start.y)
                dotproduct = (nearPoint.x - start.x) * (end.x - start.x) + (nearPoint.y - start.y)*(end.y - start.y)
                squaredlengthba = (end.x - start.x)*(end.x - start.x) + (end.y - start.y)*(end.y - start.y)

                if Math.abs(crossproduct) <= 0.000001 && dotproduct <= squaredlengthba && dotproduct >= 0
                    return segment.index

        else
            false

    selected:(activate)=>
        unless activate
            @paperPath.selected = false
        else
            @paperPath.selected = true
            
    arrayToPoint:(point)=>
        if point instanceof Array
            if point.length == 2
                if @name?
                    return point = new CC.views.draw.primitives.Point2D(point[0],point[1],name + points.length,this) 
                else
                    return point = new CC.views.draw.primitives.Point2D(point[0],point[1],null,this)
        else if point instanceof CC.views.draw.primitives.Point
            return point
        else
            return false

    rearrangePoints:=>
        i=0
        for point in @points    
            point.idx = i 
            i++

    