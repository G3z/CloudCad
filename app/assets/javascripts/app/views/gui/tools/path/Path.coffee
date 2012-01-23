### Path Tool Class###
# Path tool is used to  create planar polygons by adding one point at a time
S.export(
    "views/gui/tools/path/Path",
    ["views/gui/tools/DrawTool2D","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (DrawTool2D,Path3D,Point3D)->
        class Path extends DrawTool2D
            #### *constructor()* method takes no arguments
            #
            # `@icon` propery is overridden to contain the tool icon  
            # `@activePlane` propery is initialized to contain the plane on which the path is drawn
            # `@activePath` propery is initialized to contain the path in creation
            # `@activePoint` propery is initialized to contain the last active point (moved or added)
            # `execute_tool_Path` event is registered to fire `@do()`
            constructor:->
                super()
                @icon = "layer-shape-polygon.png"
                
                # Register callback
                $(document)
                    .bind("execute_tool_Path", =>
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
            
            #### *mouseDown()* method takes no arguments 
            # it checks if there is already an `@activePlane` otherwise the one under mouse cursor is selectedObject
            # if an `@activePlane` is present a new contact point on the plane is discovered and it is 
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
                                pos = @activePlane.position.fromObject(@activePlane.parent)
                                v = @activePlane.matrixWorld.multiplyVector3(c[0].face.normal.clone())
                                
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
                                unless @activePath?

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
                                @moveActivePointToCursor()
                                
            
            mouseDragged:=>
                unless @activePoint?.idx?
                    return
                @moveActivePointToCursor()
                
            mouseUp:=>
                #@removeDoubles()

        # Singleton
        new Path()
)

