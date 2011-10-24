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
        @stage2d.update()

    checkAlignment:(point)->
        if @path.points.length > 1
            tollerance = @stage2d.snapTolerance
            if point.idx !=0
                previousPoint = @path.point(point.idx-1)
            else
                previousPoint = @path.lastPoint

            if point.idx != @path.points.length-1
                nextPoint = @path.point(point.idx+1)
            else
                nextPoint = @path.point(0)

            if point.isNear("x",previousPoint,tollerance)
               point.moveTo(previousPoint.x,point.y)

            if point.isNear("y",previousPoint,tollerance)
                point.moveTo(point.x,previousPoint.y)

            if point.isNear("x",nextPoint,tollerance)
                point.moveTo(nextPoint.x,point.y)

            if point.isNear("y",nextPoint,tollerance)
                point.moveTo(point.x,nextPoint.y)

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
            