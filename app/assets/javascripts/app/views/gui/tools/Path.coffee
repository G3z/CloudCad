define(
    "views/gui/tools/Path",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Path extends AbstractTool

            constructor:->
                super()
                @icon = "layer-shape-polygon.png"
                @activePoint = null
            
            mouseDown:()=>
                
                c = @getMouseTarget(@stage3d.selectedObject)
                if c? and c.length>0
                    if c[0].object? and c[0].object != @stage3d.cameraPlane
                        obj = c[0].object
                        obj.material.color.setHex(0x0000bb)
                        @activePoint = obj
                    else
                        @activePoint = null
                else
                    @activePoint = null 
            
            mouseDragged:()=>
                if (!@activePoint and !@stage3d.selectedParticle) || @stage3d.mouse.btn1.delta.w * 1 != @stage3d.mouse.btn1.delta.w || @stage3d.mouse.btn1.delta.h * 1 != @stage3d.mouse.btn1.delta.h
                    return

                if @activePoint?
                    @stage3d.cameraPlane.position.copy( @activePoint.position )

                else if @stage3d.selectedParticle?
                    @stage3d.cameraPlane.position.copy( @stage3d.selectedParticle.position )

                intersects = @getMouseTarget(@stage3d.cameraPlane)
                if intersects[0]? and @activePoint.placeholder==true
                    intersects[0].object.position.copy(@activePoint.position)
                    newPoint = intersects[0].point.clone()
                    @activePoint.position.x = newPoint.x - @activePoint.father.position.x
                    @activePoint.position.y = newPoint.y - @activePoint.father.position.y

                    @stage3d.linea.movePoint(@activePoint.vertexIndex , @activePoint.position) 
            
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

