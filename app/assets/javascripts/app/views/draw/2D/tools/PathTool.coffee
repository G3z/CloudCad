class CC.views.draw.PathTool extends CC.views.draw.Tool2D
    @selectedIdx
    constructor:(stage2d)->
        super(stage2d)
        @selectedIdx=null

    mouseDown:(eventpoint)=>
        mousePoint = new CC.views.draw.primitives.Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y,"")
        @path = new CC.views.draw.primitives.Path(mousePoint) unless @path? 
        if @path.segments.length != 0
            @selectedIdx = @path.pointNear(mousePoint,@stage2d.clickTolerance)
            if @selectedIdx == null
                @path.add(mousePoint)
                @checkAlignment(@path.lastPoint)
        else
            @path.add(mousePoint)
            @checkAlignment(@path.lastPoint)
            @selectedIdx = null

    mouseDragged:(eventPoint)=>
        if @selectedIdx != null
            @path.point("selected").moveTo(eventPoint.x,eventPoint.y)
            @path.selected(true)
        else
            @path.lastPoint.moveTo(eventPoint.x,eventPoint.y)

    mouseUp:(eventPoint)=>
        if @selectedIdx != null
            @path.segments[@selectedIdx].selected=false
            @checkAlignment(@path.point("selected"))
            @selectedIdx = null
        @path.selected(false)
        @stage2d.update()

    checkAlignment:(point)->
        if point.idx !=0
            previousPoint = @path.point(point.idx-1)
            if point.x <= previousPoint.x + @stage2d.snapTolerance && point.x >= previousPoint.x - @stage2d.snapTolerance
                point.moveTo(previousPoint.x,point.y)
            if point.y <= previousPoint.y + @stage2d.snapTolerance && point.y >= previousPoint.y - @stage2d.snapTolerance
                point.moveTo(point.x,previousPoint.y)
        else
            previousPoint = @path.lastPoint
            if point.x <= previousPoint.x + @stage2d.snapTolerance && point.x >= previousPoint.x - @stage2d.snapTolerance
                point.moveTo(previousPoint.x,point.y)
            if point.y <= previousPoint.y + @stage2d.snapTolerance && point.y >= previousPoint.y - @stage2d.snapTolerance
                point.moveTo(point.x,previousPoint.y)

        if point.idx != @path.points.length-1
            nextPoint = @path.point(point.idx+1)
            if point.x <= nextPoint.x + @stage2d.snapTolerance && point.x >= nextPoint.x - @stage2d.snapTolerance
                point.moveTo(nextPoint.x,point.y)
            if point.y <= nextPoint.y + @stage2d.snapTolerance && point.y >= nextPoint.y - @stage2d.snapTolerance
                point.moveTo(point.x,nextPoint.y)
        else
            nextPoint = @path.point(0)
            if point.x <= nextPoint.x + @stage2d.snapTolerance && point.x >= nextPoint.x - @stage2d.snapTolerance
                point.moveTo(nextPoint.x,point.y)
            if point.y <= nextPoint.y + @stage2d.snapTolerance && point.y >= nextPoint.y - @stage2d.snapTolerance
                point.moveTo(point.x,nextPoint.y)
