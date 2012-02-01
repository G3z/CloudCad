### Path Tool Class###
# Path tool is used to  create planar polygons by adding one point at a time
S.export(
    "views/gui/tools/DrawTool2D",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (AbstractTool,Path3D,Point3D)->
        class DrawTool2D extends AbstractTool
            #### *constructor()* method takes no arguments
            #
            # `@icon` propery is overridden to contain the tool icon  
            # `@activePlane` propery is initialized to contain the plane on which the path is drawn
            # `@activePath` propery is initialized to contain the path in creation
            # `@activePoint` propery is initialized to contain the last active point (moved or added)
            # `execute_tool_Path` event is registered to fire `@do()`
            constructor:->
                super()
                @activePoint = null
                @activeEdge = null
                @activePlane = null
                @activePath = null
                
            #### *do()* method takes no arguments 
            # `@activePlane` propery is reset to null
            # `@activePath` propery is reset to null
            # `@activePoint` propery is reset to null
            do:=>
                super()
                @activePoint = null
                @activeEdge = null
                @activePlane = null
                @activePath = null
            
            #### *mouseDown()* method takes no arguments 
            # it checks if there is already an `@activePlane` otherwise the one under mouse cursor is selectedObject
            # if an `@activePlane` is present a new contact point on the plane is discovered and it is 
            mouseDown:=>
            
            mouseDragged:=>
            
            mouseUp:=>
                if @stage3d.layers.paths? and @activePath?
                    for path in @stage3d.layers.paths
                        contacts = null
                        if path.id != @activePath.id and path.parent.id == @activePath.parent.id
                            contacts = @activePath.intersectionWithPath(path)
                            for contact in contacts
                                @activePath.insert(contact.myIndex,contact.point)
                                path.insert(contact.otherIndex,contact.point)
            
            checkAlignment:(point)->
                if @activePath?.points.length > 1
                    tollerance = @stage3d.snapTolerance
                    foundx =false
                    foundy =false
                    zero = new Point3D()
                    for pathPoint,i in @activePath.points
                        if i != point.idx
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

                    if point.isNear("xy",zero,tollerance)
                        point.x = 0
                        point.y = 0
                    else if point.isNear("x",zero,tollerance)
                        point.x = 0
                    else if point.isNear("y",zero,tollerance)
                        point.y = 0
                    

                return point
                        

            removeIfDouble:(point)->
                if @activePath.points.length > 1
                    if point.idx !=0
                        previousPoint = @activePath.point(point.idx-1)
                    else
                        previousPoint = @activePath.point("last")

                    if point.idx != @activePath.points.length-1
                        nextPoint = @activePath.point(point.idx+1)
                    else
                        nextPoint = @activePath.point(0)
                    
                    if point.distanceTo(previousPoint) < 1
                        @activePoint = null
                        @activePath.remove(point)

                        console.log "remove #{point.idx}"
                        return false
                    
                    else if point.distanceTo(nextPoint) < 1
                        @activePoint = null
                        @activePath.remove(point)
                        console.log "remove #{point.idx}"
                        return false
                    
                    return point

            moveActivePointToCursor:=>
                intersects = @getMouseTarget(@stage3d.actionPlane)
                if intersects[0]? and @activePoint?.father?
                    newPoint = intersects[0].point.clone()
                    newPoint = newPoint.toObject(@activePlane)
                    
                    newPoint.x -= @activePoint.father.position.x
                    newPoint.y -= @activePoint.father.position.y
                    newPoint.z = 0
                    newPoint = new Point3D(newPoint.x,newPoint.y,newPoint.z)
                    newPoint.father = @activePoint.father
                    newPoint.idx = @activePoint.idx
                    if @removeIfDouble(newPoint)
                        newPoint = @checkAlignment(newPoint)
                        @stage3d.selectedObject.movePoint(@activePoint.idx , newPoint)

            isContactNearLine:(contact,tollerance)=>
                #http://paulbourke.net/geometry/pointline/
                check=(point,lineStart,lineEnd)=>
                    lineMag = lineStart.distanceTo(lineEnd)
                    U = ( ( ( point.x - lineStart.x ) * ( lineEnd.x - lineStart.x ) ) +
                        ( ( point.y - lineStart.y ) * ( lineEnd.y - lineStart.y ) ) +
                        ( ( point.z - lineStart.z ) * ( lineEnd.z - lineStart.z ) ) ) /
                        ( lineMag * lineMag )
                 
                    if( U < 0.0 || U > 1.0 )
                        return 0   # closest point does not fall within the line segment

                    intersection = new THREE.Vector3()
                    intersection.x = lineStart.x + U * ( lineEnd.x - lineStart.x )
                    intersection.y = lineStart.y + U * ( lineEnd.y - lineStart.y )
                    intersection.z = lineStart.z + U * ( lineEnd.z - lineStart.z )
                 
                    return point.distanceTo( intersection )

                face = contact.face
                object = contact.object
                point = contact.point
                console.log object
                a = object.geometry.vertices[face.a].position.fromObject(object)
                b = object.geometry.vertices[face.b].position.fromObject(object)
                c = object.geometry.vertices[face.c].position.fromObject(object)
                d = object.geometry.vertices[face.d].position.fromObject(object) if face.d?
                if face instanceof THREE.Face3
                    segments = [[a,b],[b,c],[c,a]]
                else
                    segments = [[a,b],[b,c],[c,d],[d,a]]
                

                for segment in segments
                    console.log check(point,segment[0],segment[1])
                console.log " "
)

