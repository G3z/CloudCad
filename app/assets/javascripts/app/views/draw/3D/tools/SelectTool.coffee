define(
    "views/draw/3D/tools/SelectTool",
    ["views/draw/3D/Tool3D"]
    (Tool3D)->
        class CC.views.draw.SelectTool extends Tool3D
            @selectedIdx
            constructor:(stage3d)->
                super(stage3d)
                @selectedIdx=null

            mouseDown:(eventpoint)=>
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
                            

            mouseDragged:(eventPoint)=>


            mouseUp:(eventPoint)=>
                #if @stage3d.selectedMesh?
                #    @stage3d.selectedMesh.material.color.setHex(0x53aabb)

            checkAlignment:(point)->
                if @path.points.length > 1
                    tollerance = @stage2d.snapTolerance
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