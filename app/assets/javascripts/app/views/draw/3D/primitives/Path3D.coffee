define(
    "views/draw/3D/primitives/Path3D"
    ["views/draw/3D/primitives/Primitive","views/draw/3D/primitives/Point3D","views/draw/3D/primitives/Segment"],
    (Primitive,Point3D,Segment)->
        ### Path3d Class###
        # Path3d is a class that is used to draw closed path in the system
        class CC.views.draw.primitives.Path3D extends Primitive
            @ThreePath
            @points
            @segments
            @plane
            @lastPoint
            @selectedPoint
            @selectedSegment

            constructor:(attr)->
                super()
                color = 0x8866ff
                if attr?.threePath?
                    @ThreePath = attr.threePath 
                else
                    if attr?.points?
                        @ThreePath = new THREE.Line(new THREE.CurvePath.prototype.createGeometry(attr.points), new THREE.LineBasicMaterial( { color: color, linewidth: 2 } ))
                    else
                        @ThreePath = new THREE.Line(new THREE.CurvePath.prototype.createGeometry([]), new THREE.LineBasicMaterial( { color: color, linewidth: 2 } ))
                if attr?.points?
                    @points = attr.points
                    #for point in attr.points
                    #    @add(point)
                    #@rearrangePoints()
                else
                    @points = []    
                
                if attr?.name?
                    @paperPath.name = @name = attr.name

                if attr? && @validatePoint(attr) != false
                    @start(@validatePoint(attr))
                else if attr?.start? and @validatePoint(attr.start) != false
                    @start(@validatePoint(attr.start))
            
            update:=>
                @lastPoint = @point("last")
                @threePath.geometry.__dirtyVertices = true
                @threePath.geometry.__dirtyNormals = true

            start:(point)=>
                point = @validatePoint(point)
                if point
                    point.idx = @points.length
                    point.father = this
                    @points.push(point)
                    @threePath.moveTo(point)

            add:(point)=>
                point = @validatePoint(point)
                if point
                    point.idx = @points.length
                    point.father = this
                    @points.push(point)
                    if @points.length>0
                        @threePath.lineTo(point)
                    else
                        @threePath.moveTo(point)

            insert:(idx,point)=>
                ###
                #debugger
                split = idx
                idx++

                if @validatePoint(point)
                    point.father = this
                    point.idx = idx
                    points_before = @points[0..split]
                    points_before.push(point)
                    points_after = @points[idx..@points.length-1]
                    @points = points_before.concat(points_after)
                    @paperPath.insert(idx,point)
                    @rearrangePoints()
                    @update()
                ###

            remove:(el)=>
                ###
                if el instanceof Point3D
                    @removePoint(el)
                else if el instanceof Segment
                    @removeSegment(el)
                ###

            removePoint:(point)=>
                ###
                @points.remove(point) if point in @points
                @paperPath.removeSegment(point.idx)
                @rearrangePoints()
                ###

            move:(el,newPos)=>
                if el instanceof Point3D
                    @movePoint(el,newPos)
                else if el instanceof Segment
                    @moveSegment(el,newPos)

            movePoint:(point,newPoint)=>
                point.moveTo(newPoint)
                @update()

            moveSegment:(el,newPos)=>

            point:(selector)=>
                ###
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
                ###
            
            pointNear:(point,tollerance)=>
                ###
                for i in [0...@segments.length]
                    if @paperPath.segments[i].point.isClose(point,tollerance)
                        @selectedPoint = i
                        return @selectedPoint
                return null
                ###
            
            segmentNear:(point,tollerance)=>
                ###
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
                ###

            selected:(activate)=>
                ###
                unless activate
                    @paperPath.selected = false
                else
                    @paperPath.selected = true
                ###
            
            validatePoint:(point)=>
                if point instanceof Array
                    if point.length == 2
                        if @name?
                            return point = new Point3D(point[0],point[1],name + points.length,this) 
                        else
                            return point = new Point3D(point[0],point[1],null,this)
                else if point instanceof Point3D
                    return point
                else
                    return false

            rearrangePoints:=>
                i=0
                for point in @points    
                    point.idx = i 
                    i++
)
            