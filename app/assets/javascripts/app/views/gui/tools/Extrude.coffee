define(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Extrude extends AbstractTool
            @activeVertices
            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"

                class Pref extends Spine.Model
                    @configure "Pref", "float_value", "bool_side"
                    
                @prefs = Pref.create(
                    "float_value": 20    
                    "bool_side": 1
                ) 
            
            mouseDown:()=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D"
                    @activeObj.extrude(@prefs.float_value)
                    @activeObj = @stage3d.selectedObject
                    @activeVertices = @activeObj.vertexIndexForFacesWithNormal(new THREE.Vector3(0,0,1))

            mouseDragged:()=>
                verts = @activeObj.mesh.geometry.vertices
                firstPoint = undefined
                for idx in @activeVertices
                    unless firstPoint?
                        firstPoint = verts[idx]
                    verts[idx].position.z += (@stage3d.mouse.btn1.delta.h - @stage3d.mouse.btn1.delta.w)  * -0.05
                if verts[0].position.z < firstPoint.position.z
                    @activeObj.mesh.flipSided = false
                else 
                    @activeObj.mesh.flipSided = true
                @activeObj.update()
    
            mouseUp:()=>
            
            prefChange:(prefModel)=>
                #TODO: aggiornare estrusione

        # Singleton
        tool = new Extrude()
        CC.views.gui.tools[tool.class] = tool
)