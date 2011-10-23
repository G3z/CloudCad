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
                @selectedIdx = null
                @path.add(mousePoint)
        else
            @path.add(mousePoint)
            @selectedIdx = null

    mouseDragged:(eventPoint)=>
        if @selectedIdx != null
            @path.point("selected").moveTo(eventPoint.x,eventPoint.y)
            @path.selected=true
        else
            @path.lastPoint=eventPoint

    mouseUp:(eventPoint)=>
        if @selectedIdx != null
            @path.segments[@selectedIdx].selected=false
            @selectedIdx = null
        @path.selected=false
        @stage2d.update()