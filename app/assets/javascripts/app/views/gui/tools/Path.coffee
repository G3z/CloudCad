### Path Tool Class###
# Path tool is used to  create planar polygons by adding one point at a time
S.export(
    "views/gui/tools/Path",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (AbstractTool,Path3D,Point3D)->
        class Path extends AbstractTool
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
                @activePoint = null
                @activePlane = null
                @activePath = null
                
                # Register callback
                $(document).bind("execute_tool_Path", =>
                    @do()
                )
            #### *do()* method takes no arguments 
            # `@activePlane` propery is reset to null
            # `@activePath` propery is reset to null
            # `@activePoint` propery is reset to null
            do:=>
                super()
                @activePoint = null
                @activePlane = null
                @activePath = null
            
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
                            @activePlane = obj.father
                            @stage3d.cameraController.normalTo(@activePlane)
                    else
                        @activePlane = null
                else if @activePlane?
                    c = @getMouseTarget(@activePlane)
                    if c? and c.length>0
                        if c[0].point?
                            contactPoint = c[0].point
                            originalPoint = contactPoint.clone()
                            if contactPoint?
                                console.log contactPoint
                                #mat = new THREE.Matrix4()
                                #contactPoint = mat.getInverse(@activePlane.matrix).multiplyVector3(contactPoint.clone())
                                #console.log contactPoint
                                contactPoint.subSelf(@activePlane.position)
                                #creo una nuova Path
                                unless @activePath?

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
                                console.log @activePath.point("last").position
                                
            
            mouseDragged:=>
                unless @activePoint?.vertexIndex?
                    return
                @moveOnPlane(@activePoint.position)
                
            moveOnPlane:(point)=>
                if @activePoint?
                    @stage3d.cameraPlane.position.copy( point )
                    #@stage3d.cameraPlane.rotation.copy(@activePoint.father.rotation)

                intersects = @getMouseTarget(@stage3d.cameraPlane)
                if intersects[0]? and @activePoint.placeholder==true
                    intersects[0].object.position.copy(@activePoint.position)
                    newPoint = intersects[0].point.clone()
                    mat = new THREE.Matrix4()
                    newPoint = mat.getInverse(@activePlane.matrix).multiplyVector3(newPoint.clone())

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
        new Path()
)

