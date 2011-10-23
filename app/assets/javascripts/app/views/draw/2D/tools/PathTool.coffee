class CC.views.draw.PathTool extends CC.views.draw.Tool2D
    constructor:(stage2d)->
        super(stage2d)

    mouseDown:(point)=>
        mousePoint = new Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y)
        if @path.segments.length != 0
            for i in [0...@path.segments.length]
                if @path.segments[i].point.getDistance(mousePoint,false)<@stage2d.clickTolerance
                    @stage2d.selected = i
                
            if @stage2d.selected == null
                @stage2d.selected = null
                @createPath()
        else
            @createPath()
            @stage2d.selected = null

    mouseDragged:(destPoint)=>
        if @stage2d.selected != null
            @path.segments[@stage2d.selected].point.x = destPoint.x
            @path.segments[@stage2d.selected].point.y = destPoint.y
            @path.selected=true
        else
            @path.lastSegment.point=destPoint
        @stage2d.update()

    mouseUp:(destPoint)=>
        @stage2d.selected = null
        @path.selected=false
        @stage2d.update()

    createPath:=>
        if (@path.segments.length == 0)
            @path.add(@stage2d.mouse.currentPos)
        @path.add(@stage2d.mouse.currentPos)
        @stage2d.update()