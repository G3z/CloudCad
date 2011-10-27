class CC.views.draw.SelectTool extends CC.views.draw.Tool2D
    @selectedIdx
    constructor:(stage2d)->
        super(stage2d)
        @selectedIdx=null

    mouseDown:(eventpoint)=>
        mousePoint = new CC.views.draw.primitives.Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y,"")
        #debugger
        @path = @stage2d.activePath
        hitTest = paper.project.hitTest(mousePoint)
        if hitTest?
            if @path? && @path.id != hitTest.item.ccObject.id
                @path.selected(false)
                for segment in @path.paperPath.segments
                    segment.selected = false
                @path.update()
                @stage2d.activePath = null
                @path = null

                @path = hitTest.item.ccObject
                @path.selected(true)
                for segment in @path.paperPath.segments
                    segment.selected = true
                @path.update()
                @stage2d.activePath = @path
            else if @path? && @path.id == hitTest.item.ccObject.id
                @path.selected(true)
                for segment in @path.paperPath.segments
                    segment.selected = true
                @path.update()
                @stage2d.activePath = @path
            else
                if hitTest.item.ccObject instanceof CC.views.draw.primitives.Path
                    @path = hitTest.item.ccObject
                    @path.selected(true)
                    for segment in @path.paperPath.segments
                        segment.selected = true
                    @path.update()
                    @stage2d.activePath = @path
        else if @path?
            @path.selected(false)
            for segment in @path.paperPath.segments
                segment.selected = false
            @path.update()
            @stage2d.activePath = null
            @path = null

                    

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