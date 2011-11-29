define(
    "views/draw/3D/tools/PathTool",
    ["views/draw/3D/Tool3D"]
    (Tool3D)->
        class CC.views.draw.PathTool extends Tool3D
            @selectedIdx
            constructor:(stage3d)->
                super(stage3d)
                @selectedIdx=null

            mouseDown:(eventpoint)=>
                ###
                mousePoint = new CC.views.draw.primitives.Point2D(@stage3d.mouse.currentPos.x, @stage3d.mouse.currentPos.y,"")
                if @stage3d.activePath? 
                    @path =  @stage3d.activePath
                else
                   @path = new CC.views.draw.primitives.Path(mousePoint)
                   @stage3d.activePath = @path

                if @path.segments.length != 0
                    @selectedIdx = @path.pointNear(mousePoint,@stage3d.clickTolerance)
                    if @selectedIdx == null
                        if @path.segments.length >= 1 && @path.segmentNear({x:mousePoint.x,y:mousePoint.y},@stage3d.clickTolerance) != false
                            idx = @path.segmentNear({x:mousePoint.x,y:mousePoint.y},@stage3d.clickTolerance)
                            @path.insert(idx,mousePoint)
                            @selectedIdx = @path.pointNear(mousePoint,@stage3d.clickTolerance)
                        else
                            @path.add(mousePoint)
                            @checkAlignment(@path.lastPoint)
                else
                    @path.add(mousePoint)
                    @checkAlignment(@path.lastPoint)
                    @selectedIdx = null
                ###

            mouseDragged:(eventPoint)=>
                if (!@stage3d.selectedMesh and !@stage3d.selectedParticle) || @stage3d.mouse.btn1.delta.w * 1 != @stage3d.mouse.btn1.delta.w || @stage3d.mouse.btn1.delta.h * 1 != @stage3d.mouse.btn1.delta.h
                    return

                if @stage3d.selectedMesh?
                    @stage3d.cameraPlane.position.copy( @stage3d.selectedMesh.position )

                else if @stage3d.selectedParticle?
                    @stage3d.cameraPlane.position.copy( @stage3d.selectedParticle.position )

                intersects = @getMouseTarget(@stage3d.cameraPlane)
                if intersects[0]? and @stage3d.selectedMesh.placeholder==true
                    intersects[0].object.position.copy(@stage3d.selectedMesh.position)
                    newPoint = intersects[0].point.clone()
                    @stage3d.selectedMesh.position.x = newPoint.x
                    @stage3d.selectedMesh.position.y = newPoint.y

                    @stage3d.linea.movePoint(@stage3d.selectedMesh.vertexIndex , @stage3d.selectedMesh.position) 
                    
            mouseUp:(eventPoint)=>
                ###
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
                ###

            checkAlignment:(point)->
                if @path.points.length > 1
                    tollerance = @stage3d.snapTolerance
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