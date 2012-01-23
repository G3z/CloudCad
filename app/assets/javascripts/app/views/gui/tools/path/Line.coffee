### Line Tool Class###
# line tool is used to create planar Lines
S.export(
    "views/gui/tools/path/Line",
    ["views/gui/tools/DrawTool2D","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (DrawTool2D,Path3D,Point3D)->
        class Line extends DrawTool2D
            constructor:->
                super()
                @icon = "layer-shape-line.png"                
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
                else
                    c = @getMouseTarget(@stage3d.actionPlane)
                    if c? and c.length>0
                        if c[0].point?
                            contactPoint = c[0].point
                            originalPoint = contactPoint.clone()
                            if contactPoint?
                                contactPoint = contactPoint.fromObject(@stage3d.actionPlane)
                                mat = new THREE.Matrix4()
                                contactPoint = mat.getInverse(@activePlane.matrix).multiplyVector3(contactPoint.clone())
                                #creo una nuova Path
                                if @activePath?.points?.length > 1 or not @activePath?

                                    @activePath = new Path3D({points:[contactPoint]})
                                    @activePath.toggleSelection() unless @activePath.selected
                                    @activePlane.add(@activePath)
                                    @stage3d.selectedObject = @activePath
                                    @activePoint = @activePath.point("last")
                                #aggiungo punti ad alla Path attiva
                                else
                                    pathContact = @nearPoint(originalPoint.toObject(@activePath.parent))
                                    if pathContact?
                                        if _.isArray(pathContact)
                                            @activeEdge = pathContact
                                        else
                                            @activePoint = pathContact
                                    else
                                        @activePath.lineTo(contactPoint)
                                        @activePoint = @activePath.point("last")
                                @moveOnPlane()
                                
            
            mouseDragged:=>
                unless @activePoint?.idx?
                    return
                @moveOnPlane()

            mouseUp:=>
                #@removeDoubles()

        # Singleton
        new Line()
)
