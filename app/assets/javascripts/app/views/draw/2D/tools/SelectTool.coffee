class CC.views.draw.SelectTool extends CC.views.draw.Tool2D
    @selectedIdx
    constructor:(stage2d)->
        super(stage2d)
        @selectedIdx=null

    mouseDown:(eventpoint)=>
        mousePoint = new CC.views.draw.primitives.Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y,"")
        if paper.project.hitTest(mousePoint)?
            if @path?
                @path.selected(false)
                for segment in @path.paperPath.segments
                    segment.selected = false
            @path = new CC.views.draw.primitives.Path(null,null,paper.project.hitTest(mousePoint).item)
        if @path?    
            @path.paperPath.selected=true
            @path.update()
            @stage2d.activePath = @path
            if @path.segments.length != 0
                @selectedIdx = @path.pointNear(mousePoint,@stage2d.clickTolerance)
            @path.update()

    mouseDragged:(eventPoint)=>


    mouseUp:(eventPoint)=>
        if @path?
            if @selectedIdx != null
                @path.segments[@selectedIdx].selected=false
                @checkAlignment(@path.point("selected"))
                @removeIfDouble(@path.point("selected"))
                @selectedIdx = null
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