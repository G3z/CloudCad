### Line Tool Class###
# line tool is used to create planar Lines
S.export(
    "views/gui/tools/path/Line",
    [
        "views/gui/tools/DrawTool2D",
        "views/draw/3D/primitives/Path3D",
        "views/draw/3D/primitives/Point3D"
        "models/Action",
        "views/gui/History"
    ],
    (DrawTool2D ,Path3D, Point3D, Action, History)->
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
                super()
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
                            originalPoint = c[0].point.clone()
                            contactPoint = originalPoint.toObject(@activePlane)
                            if contactPoint?
                                #creo una nuova Path
                                if @activePath?.points?.length > 1 or not @activePath?
                                    @activePath = new Path3D({points:[contactPoint]})
                                    @activePath.toggleSelection() unless @activePath.selected
                                    @activePlane.add(@activePath)
                                    @stage3d.selectedObject = @activePath
                                    @activePoint = @activePath.point("last")
                                    # Save the new Action
                                    action = new Action({
                                        label: "Line"
                                        data: @activePath.store()
                                        time: new Date()
                                    })

                                    History.addAction(action)

                                #aggiungo punti ad alla Path attiva
                                else
                                    pathPoint = @activePath.pointNear(contactPoint,@stage3d.snapTolerance)
                                    if pathPoint?
                                        @activePoint = pathPoint
                                    else
                                        pathEdge = @activePath.segmentNear(contactPoint,@stage3d.snapTolerance)
                                        if pathEdge?
                                            @activePoint = null
                                            @activeEdge = pathEdge
                                        else
                                            @activePath.lineTo(contactPoint)
                                            @activePoint = @activePath.point("last")
                                            @moveActivePointToCursor()

                                        action = History.getLastAction()
                                        action.set("data", @activePath.store())
                                
            
            mouseDragged:=>
                super()
                unless @activePoint?.idx?
                    return
                @moveActivePointToCursor()

            mouseUp:=>
                super()
                #@removeDoubles()

        # Singleton
        new Line()
)
