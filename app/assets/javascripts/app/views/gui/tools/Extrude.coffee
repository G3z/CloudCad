S.export(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool", "views/gui/tools/ToolOption"],
    (AbstractTool, ToolOption)->

        class Extrude extends AbstractTool
            @activeVertices
            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"

                class Pref extends ToolOption
                    # @configure "Pref", "float_value", "bool_side"
                    
                @prefs = new Pref(
                    "float_value": 20
                    "bool_side": false
                )
                
                # Set labels
                @prefs.setLabel("float_value", "Extrusion value")
                @prefs.setLabel("bool_side", "Booth sides")

                # Register callback
                $(document).bind("execute_tool_Extrude", =>
                    @do()
                )

            mouseDown:=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D"
                    @activeObj.extrude(@prefs.get('float_value'))
                    @activeObj = @stage3d.selectedObject
                    @activeVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,1),"vertexIndices")
                    @prefs.set({
                        'float_value': @prefs.get('float_value'),
                        'bool_side': @prefs.get('bool_side')
                    })

            mouseDragged:=>
                if @activeObj?.class == "Solid3D"
                    if @activeVertices.length? and @activeVertices.length >0
                        verts = @activeObj.mesh.geometry.vertices
                        h = @stage3d.mouse.btn1.delta.h
                        w = @stage3d.mouse.btn1.delta.w

                        distance = Math.sqrt(w*w + h*h)
                        if h >= w
                            distance *= 1
                        else
                            distance *= -1
                        value = verts[@activeVertices[0]].position.z + distance * 0.05
                        value = Math.round(value*1000)/1000
                        @prefs.set({'float_value': value})

                        return value
            
            mouseUp:=>
            
            prefChange:(prefModel)=>
                #console.log @prefs.float_value
                $(".float_value").val(@prefs.get('float_value'))
                $(".bool_side").attr('checked',@prefs.get('bool_side'))
                @moveExtrudedFaces(parseFloat(@prefs.get('float_value')))

            moveExtrudedFaces:(ammount)=>
                if @activeVertices?.length? and @activeVertices?.length >0
                    verts = @activeObj.mesh.geometry.vertices
                    firstPoint = undefined
                    for idx in @activeVertices
                        unless firstPoint?
                            firstPoint = verts[idx]
                        verts[idx].position.z = ammount
                    
                    if verts[0].position.z < firstPoint.position.z
                        @activeObj.mesh.flipSided = false
                    else 
                        @activeObj.mesh.flipSided = true
                    
                    @activeObj.update()


        # Singleton
        new Extrude()

)
