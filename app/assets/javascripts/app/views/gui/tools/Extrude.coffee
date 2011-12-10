define(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Extrude extends AbstractTool
            @activeVertices
            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"
            
            mouseDown:()=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D"
                    @activeObj.extrude(20)
                    @activeObj = @stage3d.selectedObject
                    @activeVertices = @activeObj.vertexIndexForFacesWithNormal(new THREE.Vector3(0,0,1))
                    console.log @activeVertices

            mouseDragged:()=>
                verts = @activeObj.mesh.geometry.vertices
                firstPoint = undefined
                for idx of @activeVertices
                    unless firstPoint?
                        firstPoint = verts[idx]
                    verts[idx].position.z += (@stage3d.mouse.btn1.delta.h - @stage3d.mouse.btn1.delta.w)  * -0.05
                if verts[0].position.z < firstPoint.position.z
                    @activeObj.mesh.flipSided = false
                else 
                    @activeObj.mesh.flipSided = true
                @activeObj.update()

            mouseUp:()=>

        # Singleton
        tool = new Extrude()
        CC.views.gui.tools[tool.class] = tool
)