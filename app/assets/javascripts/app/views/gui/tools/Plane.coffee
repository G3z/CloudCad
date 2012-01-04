S.export(
    "views/gui/tools/Plane",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Plane3D"],
    (AbstractTool,Plane3D)->
        class Plane extends AbstractTool

            constructor:->
                super()
                @icon = "border-all.png"
                @SM = {} #Selected Mesh
                
                # Register callback
                $(document).bind("execute_tool_Plane", =>
                    @do()
                )

            mouseDown:()=>
                if @stage3d.layers.solids? and @stage3d.layers.planes?
                    c = @getMouseTarget([@stage3d.layers.solids,@stage3d.layers.planes])
                else if @stage3d.layers.solids? and not @stage3d.layers.planes?
                    c = @getMouseTarget(@stage3d.layers.solids)
                else if not @stage3d.layers.solids? and @stage3d.layers.planes?
                    c = @getMouseTarget(@stage3d.layers.planes)
                else
                    return
                if c? and c.length>0
                    if c[0].object? and c[0].face?
                        obj = c[0].object.father 
                        face = c[0].face
                        point = c[0].point
                        if obj.class == "Solid3D"
                            normal = face.normal
                            faceVertices = obj.facesWithNormal(face.normal,"vertex")
                            barycenter = @getBarycenter faceVertices

                            emptyObj = new THREE.Object3D()
                            emptyObj.position = barycenter

                            #
                            v = new THREE.Vector3()
                            v.add(barycenter,normal)
                            emptyObj.lookAt(v)

                            geo = new THREE.Geometry()
                            geo.vertices = faceVertices
                            geo.computeBoundingBox()
                            w = geo.boundingBox.x[0]-geo.boundingBox.x[1]
                            h = geo.boundingBox.y[0]-geo.boundingBox.y[1]
                            #debugger
                            
                            plane = new Plane3D(
                                position: barycenter
                                rotation: emptyObj.rotation.addSelf(new THREE.Vector3(0,Math.toRadian(180),0))
                                size:
                                    w:Math.abs(w)+10
                                    h:Math.abs(h)+10
                                normalSize:Math.abs((w*2+h*2)/20)
                                color: 0xccaabb
                            )
                            obj.add plane
                            

            mouseDragged:()=>


            mouseUp:()=>
            

        # Singleton
        new Plane()
)
