define(
    "views/gui/tools/Plane",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Plane3D"],
    (AbstractTool,Plane3D)->
        class Plane extends AbstractTool

            constructor:->
                super()
                @icon = "border-all.png"
                @SM = {} #Selected Mesh

            mouseDown:()=>
                c = @getMouseTarget([@stage3d.world,@stage3d.planes])
                if c? and c.length>0
                    if c[0].object? and c[0].face?
                        obj = c[0].object.father 
                        face = c[0].face
                        point = c[0].point
                        if obj.class == "Solid3D"
                            faceVertices = obj.facesWithNormal(face.normal,"vertex")
                            geo = new THREE.Geometry()
                            geo.vertices = faceVertices
                            geo.computeBoundingBox()
                            w = geo.boundingBox.x[0]-geo.boundingBox.x[1]+10
                            h = geo.boundingBox.y[0]-geo.boundingBox.y[1]+10
                            #debugger
                            barycenter = @getBarycenter faceVertices
                            plane = new Plane3D(
                                position: barycenter
                                size:
                                    w:Math.abs(w)
                                    h:Math.abs(h)
                            )
                            @stage3d.planes.add(plane)
                            
                        #console.log obj.father,face,point

            mouseDragged:()=>


            mouseUp:()=>
            

        # Singleton
        tool = new Plane()
        CC.views.gui.tools[tool.class] = tool
)