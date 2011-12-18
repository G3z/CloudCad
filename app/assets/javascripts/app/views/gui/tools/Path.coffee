define(
    "views/gui/tools/Path",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (AbstractTool,Path3D,Point3D)->
        class Path extends AbstractTool

            constructor:->
                super()
                @icon = "layer-shape-polygon.png"
                @activePoint = null
                @activePlane = null
                @activePath = null

            do:=>
                super()
                @activePoint = null
                @activePlane = null
                @activePath = null

            mouseDown:=>
                if @stage3d.selectedObject? and @stage3d.selectedObject.class == "Path3D"
                    c = @getMouseTarget(@stage3d.selectedObject)
                    if c? and c.length>0
                        if c[0].object?
                            obj = c[0].object
                            obj.material.color.setHex(0x0000bb)
                            @activePoint = obj
                        else
                            @activePoint = null
                    else
                        @activePoint = null

                #Seleziono il piano su cui lavorare
                unless @activePlane?
                    c = @getMouseTarget([@stage3d.planes,@stage3d._planes])
                    if c? and c.length>0
                        if c[0].object?
                            obj = c[0].object
                            @activePlane = obj.father
                            @stage3d.cameraController.normalTo(@activePlane)
                            if @stage3d.camera.inPersepectiveMode
                                @stage3d.camera.toggleType()
                    else
                        @activePlane = null
                else if @activePlane?
                    c = @getMouseTarget(@activePlane)
                    if c? and c.length>0
                        if c[0].point?
                            contactPoint = c[0].point
                            contactPoint = @activePlane.matrix.multiplyVector3(contactPoint.clone())
                            if contactPoint?
                                #creo una nuova Path
                                unless @activePath?

                                    @activePath = new Path3D({points:[contactPoint]})
                                    planeRotation = @activePlane.rotation.clone()
                                    @activePath.rotation = planeRotation.multiplyScalar(-1)
                                    @activePath.toggleSelection() unless @activePath.selected
                                    @stage3d.world.add(@activePath)
                                    @stage3d.selectedObject = @activePath
                                    @activePoint = @activePath.point("last")
                                #aggiungo punti ad alla Path attiva
                                else
                                    pathContact = @getMouseTarget(@activePath)
                                    if pathContact? and pathContact.length>0
                                        if pathContact[0].object?
                                            obj = pathContact[0].object
                                            if obj.father?
                                                obj.father.toggleSelection() unless obj.father.selected
                                                @activePoint = obj
                                        else
                                            @activePath.lineTo(contactPoint)
                                            @activePoint = @activePath.point("last")
                                    else
                                        @activePath.lineTo(contactPoint)
                                        @activePoint = @activePath.point("last")
                                
            
            mouseDragged:=>
                unless @activePoint?.vertexIndex?
                    return
                if @activePoint?
                    @stage3d.cameraPlane.position.copy( @activePoint.position )
                    #@stage3d.cameraPlane.rotation.copy(@activePoint.father.rotation)

                intersects = @getMouseTarget(@stage3d.cameraPlane)
                if intersects[0]? and @activePoint.placeholder==true
                    intersects[0].object.position.copy(@activePoint.position)
                    newPoint = intersects[0].point.clone()
                    newPoint = @activePlane.matrix.multiplyVector3(newPoint.clone())

                    newPoint.x -= @activePoint.father.position.x
                    newPoint.y -= @activePoint.father.position.y
                    newPoint.z = 0
                    newPoint = new Point3D(newPoint.x,newPoint.y,newPoint.z)
                    newPoint.vertexIndex = @activePoint.vertexIndex
                    newPoint = @checkAlignment(newPoint)

                    @stage3d.selectedObject.movePoint(@activePoint.vertexIndex , newPoint)
                    
            mouseUp:=>
                #@removeDoubles()

            checkAlignment:(point)->
                if @activePath?.points.length > 1
                    tollerance = @stage3d.snapTolerance
                    foundx =false
                    foundy =false
                    for pathPoint,i in @activePath.points
                        if i != point.vertexIndex
                            if point.isNear("xy",pathPoint,tollerance)
                                point.x = pathPoint.x
                                point.y = pathPoint.y
                                return point

                            else if point.isNear("x",pathPoint,tollerance)
                               point.x = pathPoint.x
                               foundx = true

                            else if point.isNear("y",pathPoint,tollerance)
                                point.y = pathPoint.y
                                foundy = true

                            if foundx and foundy
                                return point

                return point
                        

            removeIfDouble:(point)->
                if @activePath.points.length > 1
                    if point.idx !=0
                        previousPoint = @activePath.point(point.idx-1)
                    else
                        previousPoint = @activePath.lastPoint

                    if point.idx != @activePath.points.length-1
                        nextPoint = @activePath.point(point.idx+1)
                    else
                        nextPoint = @activePath.point(0)
                    
                    if point.isNear("xyz",previousPoint,0)
                        point.remove()
                    
                    if point.isNear("xyz",nextPoint,0)
                        point.remove()

        # Singleton
        tool = new Path()
        CC.views.gui.tools[tool.class] = tool
)

