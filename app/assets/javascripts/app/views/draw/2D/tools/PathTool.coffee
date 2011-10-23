class CC.views.draw.PathTool extends CC.views.draw.Tool2D
    @selected
    constructor:(stage2d)->
        super(stage2d)
        @selected=null

    mouseDown:(eventpoint)=>
        mousePoint = new Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y)
        if @path.segments.length != 0
            for i in [0...@path.segments.length]
                if @path.segments[i].point.isClose(mousePoint,@stage2d.clickTolerance)
                    @selected = i
                    break
            if @selected == null
                @selected = null
                @createPath()
        else
            @createPath()
            @selected = null

    mouseDragged:(eventPoint)=>
        if @selected != null
            @path.segments[@selected].point.x = eventPoint.x
            @path.segments[@selected].point.y = eventPoint.y
            @path.segments[@selected].selected=true
            @path.selected=true
        else
            @path.lastSegment.point=eventPoint
        @stage2d.update()

    mouseUp:(eventPoint)=>
        if @selected != null
            @path.segments[@selected].selected=false
            @selected = null
        @path.selected=false
        @stage2d.update()

    createPath:=>
        if (@path.segments.length == 0)
            @path.add(@stage2d.mouse.currentPos)
        @path.add(@stage2d.mouse.currentPos)
        @stage2d.update()