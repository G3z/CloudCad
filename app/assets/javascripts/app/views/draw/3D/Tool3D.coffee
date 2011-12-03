define(
    "views/draw/3D/Tool3D"
    ()->
        class CC.views.draw.Tool3D
            @active
            @path
            @stage3d
            constructor:()->
                @stage3d = window.stage3d
                @path = @stage3d.activePath
                @active = false

            getMouseTarget:(object)=>  
                if @stage3d.camera.inPersepectiveMode
                    vector = new THREE.Vector3(
                        @stage3d.mouse.currentPos.stage3Dx
                        @stage3d.mouse.currentPos.stage3Dy
                        0.5
                    )
                    @stage3d.projector.unprojectVector(vector, @stage3d.camera)
                    ray = new THREE.Ray(@stage3d.camera.position, vector.subSelf( @stage3d.camera.position ).normalize())
                    if object? 
                        return ray.intersectObject(object) 
                    else 
                        return ray.intersectObject(@stage3d.world)
                else
                    vecOrigin = new THREE.Vector3( 
                        @stage3d.mouse.currentPos.stage3Dx
                        @stage3d.mouse.currentPos.stage3Dy
                        -1
                    )
                    vecTarget = new THREE.Vector3( 
                        @stage3d.mouse.currentPos.stage3Dx
                        @stage3d.mouse.currentPos.stage3Dy
                        1
                    )

                    @stage3d.projector.unprojectVector( vecOrigin, @stage3d.camera )
                    @stage3d.projector.unprojectVector( vecTarget, @stage3d.camera )
                    vecTarget.subSelf( vecOrigin ).normalize()
                    ray = new THREE.Ray( @stage3d.camera.position, vecTarget.subSelf( @stage3d.camera.position ).normalize())
                    ray.origin = vecOrigin
                    ray.direction = vecTarget
                    if object?
                        return ray.intersectObject(object) 
                    else
                        return ray.intersectObject(@stage3d.world)
)