define(
    "views/draw/3D/tools/PathTool",
    ["views/draw/3D/Tool3D"]
    (Tool3D)->
        class CC.views.draw.PathTool extends Tool3D
            @selectedIdx
            constructor:(stage2d)->
                super(stage2d)
                @selectedIdx=null

            mouseDown:(eventpoint)=>
                mousePoint = new CC.views.draw.primitives.Point2D(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y,"")
                if @stage2d.activePath? 
                    @path =  @stage2d.activePath
                else
                   @path = new CC.views.draw.primitives.Path(mousePoint)
                   @stage2d.activePath = @path

                if @path.segments.length != 0
                    @selectedIdx = @path.pointNear(mousePoint,@stage2d.clickTolerance)
                    if @selectedIdx == null
                        if @path.segments.length >= 1 && @path.segmentNear({x:mousePoint.x,y:mousePoint.y},@stage2d.clickTolerance) != false
                            idx = @path.segmentNear({x:mousePoint.x,y:mousePoint.y},@stage2d.clickTolerance)
                            @path.insert(idx,mousePoint)
                            @selectedIdx = @path.pointNear(mousePoint,@stage2d.clickTolerance)
                        else
                            @path.add(mousePoint)
                            @checkAlignment(@path.lastPoint)
                else
                    @path.add(mousePoint)
                    @checkAlignment(@path.lastPoint)
                    @selectedIdx = null

            mouseDragged:(eventPoint)=>
                if @selectedIdx != null
                    @path.point("selected").moveTo(eventPoint.x,eventPoint.y)
                    @checkAlignment(@path.point("selected"))
                    @path.selected(true)
                else
                    @path.lastPoint.moveTo(eventPoint.x,eventPoint.y)
                    @checkAlignment(@path.point("last"))

            mouseUp:(eventPoint)=>
                if @selectedIdx != null
                    @path.segments[@selectedIdx].selected=false
                    @checkAlignment(@path.point("selected"))
                    @removeIfDouble(@path.point("selected"))
                    @selectedIdx = null
                else
                    @checkAlignment(@path.point("last"))
                    @removeIfDouble(@path.point("last"))
                @path.selected(false)
                for segment in @path.paperPath.segments
                    segment.selected = false

            checkAlignment:(point)->
                if @path.points.length > 1
                    tollerance = @stage2d.snapTolerance
                    for pathPoint in @path.points
                        if point.isNear("x",pathPoint,tollerance)
                           point.moveTo(pathPoint.x,point.y)

                        if point.isNear("y",pathPoint,tollerance)
                            point.moveTo(point.x,pathPoint.y)

            removeIfDouble:(point)->
                if @path.points.length > 1
                    if point.idx !=0
                        previousPoint = @path.point(point.idx-1)
                    else
                        previousPoint = @path.lastPoint

                    if point.idx != @path.points.length-1
                        nextPoint = @path.point(point.idx+1)
                    else
                        nextPoint = @path.point(0)
                    
                    if point.isNear("xy",previousPoint,0)
                        point.remove()
                    
                    if point.isNear("xy",nextPoint,0)
                        point.remove()
)