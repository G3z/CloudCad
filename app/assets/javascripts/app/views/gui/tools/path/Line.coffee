S.export(
    "views/gui/tools/path/Line",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (AbstractTool,Path3D,Point3D)->
        class Line extends AbstractTool

            constructor:->
                super()
                @icon = "layer-shape-line.png"
                @activePoint = null
                @activePlane = null
                @activePath = null
                
                # Register callback
                
                # Register callback
                $(document)
                    .bind("execute_tool_Line", =>
                        @do()
                    )
                    .bind("current_tool_changed", (evt, tool)=>
                        
                        if tool.toolName == "drawTool"
                            self = this
                            _.delay(()->
                            
                                S.import(["views/gui/SecondToolbar"], (SecondToolbar)->
                                    $(SecondToolbar.el).append($(self.button()))
                                )
                            , 50) # Mi assicuro che arrivi dopo lo svuotamento
                                
                    )
            do:=>
                super()
                @activePoint = null
                @activePlane = null
                @activePath = null

            mouseDown:=>
                #Seleziono il piano su cui lavorare
                unless @activePlane?
                    c = @getMouseTarget([@stage3d.layers.planes,@stage3d.layers.originPlanes])
                    if c? and c.length>0
                        if c[0].object?
                            obj = c[0].object
                            
                            if obj.father.class == "Plane3D"
                                @activePlane = obj.father
                                
                                #`stage3d.actionPlane` is positioned and rotated as the selected plane
                                #v = new THREE.Vector3()
                                pos = @activePlane.position.fromObject(@activePlane.parent)
                                v = @activePlane.matrixWorld.multiplyVector3(c[0].face.normal.clone())
                                #v.add(pos,@activePlane.matrixWorld.multiplyVector3(c[0].face.normal.clone()))
                                
                                @stage3d.actionPlane.position.copy(pos)
                                @stage3d.actionPlane.up.copy(@activePlane.up)
                                @stage3d.actionPlane.lookAt(v)
                                @stage3d.cameraController.normalTo(@activePlane)
                                
                    else
                        @activePlane = null

                else if @activePlane?
                    c = @getMouseTarget(@stage3d.actionPlane)
                    if c? and c.length>0
                        if c[0].point?
                            contactPoint = c[0].point
                            originalPoint = contactPoint.clone()
                            if contactPoint?
                                contactPoint = contactPoint.fromObject(@stage3d.actionPlane)
                                mat = new THREE.Matrix4()
                                contactPoint = mat.getInverse(@activePlane.matrix).multiplyVector3(contactPoint.clone())
                                #contactPoint.subSelf(@activePlane.position)
                                #creo una nuova Path
                                if @activePath?.points?.length > 1 or not @activePath?

                                    @activePath = new Path3D({points:[contactPoint]})
                                    @activePath.toggleSelection() unless @activePath.selected
                                    @activePlane.add(@activePath)
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
                                @moveOnPlane(originalPoint)
                                
            
            mouseDragged:=>
                unless @activePoint?.vertexIndex?
                    return
                @moveOnPlane(@activePoint.position)
                
            moveOnPlane:(point)=>
                #if @activePoint?
                #    console.log @activePoint
                    #@stage3d.cameraPlane.position.copy( @vectorToWorldSpace(@activePlane.position,@activePlane) )
                    #@stage3d.cameraPlane.rotation.copy(@activePoint.father.rotation)

                intersects = @getMouseTarget(@stage3d.actionPlane)
                if intersects[0]? and @activePoint.placeholder==true
                    #intersects[0].object.position.copy(@activePoint.position)
                    newPoint = intersects[0].point.clone()
                    
                    newPoint = newPoint.toObject(@activePlane)
                    
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
        new Line()
)
