define(
    "views/gui/tools/Path",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Path extends AbstractTool

            constructor:->
                @icon = "layer-shape-polygon.png"
                super()
            
            mouseDown:()=>
                c = @getMouseTarget(@stage3d.world)
                if c? and c.length>0
                    if c[0].object? and c[0].object != @stage3d.cameraPlane
                        obj = c[0].object
                        if @stage3d.selectedMesh?
                            @stage3d.selectedMesh.material.color.setHex(0x53aabb)
                        obj.material.color.setHex(0x0000bb)
                        @stage3d.selectedMesh = obj
                    else
                        @stage3d.selectedMesh = null
                else
                    @stage3d.selectedMesh = null
            
            mouseDragged:()=>
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
                    @stage3d.selectedMesh.position.x = newPoint.x - @stage3d.selectedMesh.father.position.x
                    @stage3d.selectedMesh.position.y = newPoint.y - @stage3d.selectedMesh.father.position.y

                    @stage3d.linea.movePoint(@stage3d.selectedMesh.vertexIndex , @stage3d.selectedMesh.position) 
            
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

        # Singleton
        tool = new Path()
        CC.views.gui.tools[tool.class] = tool
)

