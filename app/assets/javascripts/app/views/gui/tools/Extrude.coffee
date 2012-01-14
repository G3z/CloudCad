S.export(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool", "views/gui/tools/ToolOption"],
    (AbstractTool, ToolOption)->

        class Extrude extends AbstractTool
            @activeVertices
            @inactiveVertices
            #### *constructor()* method takes no arguments  
            # 
            # 
            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"

                class Pref extends ToolOption
                    # @configure "Pref", "float_value", "bool_side"
                    
                @prefs = new Pref(
                    float_value: 50
                    bool_side: false
                    float_angle: 0
                )
                
                # Set labels
                @prefs.setLabel("float_value", "Extrusion value")
                @prefs.setLabel("bool_side", "Booth sides")
                @prefs.setLabel("float_angle", "Extrusion angle")

                # Register callback
                $(document).bind("execute_tool_Extrude", =>
                    @do()
                    $(".float_value").val(@prefs.get('float_value'))
                    $(".bool_side").attr('checked',@prefs.get('bool_side'))
                    $(".float_angle").val(@prefs.get('float_angle'))
                )
            
            #### *mouseDown()* method takes no arguments 
            # it checks if the active object is an instance of Path3D with more than 2 points  
            # the path is extruded and the new solid become the selectedObject  
            # `@activeVertices` contains the vertex of the new face while `@inactiveVertices` contains the vertices of the base  
            # `@prefs` are reset
            mouseDown:=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D" and @activeObj.points.length > 2
                    @activeObj.extrude(@prefs.get('float_value'))
                    @activeObj = @stage3d.selectedObject
                    @activeVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,1),"vertexIndices")
                    @inactiveVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,-1),"vertexIndices")
                    @prefs.set
                        float_value: @prefs.get('float_value')
                        bool_side: @prefs.get('bool_side')
                        float_angle: @prefs.get('float_angle')
            
            #### *mouseDragged()* method takes no arguments 
            # It checks if the active object is an instance of Solid3D  
            # A new extrusion ammount is calculad based on mouse movement  
            # `@prefs.float_value` is updated with the new value of the extrusion
            mouseDragged:=>
                if @activeObj?.class == "Solid3D"
                    if @activeVertices.length? and @activeVertices.length >0
                        verts = @activeObj.mesh.geometry.vertices
                        h = @stage3d.mouse.btn1.delta.h
                        w = @stage3d.mouse.btn1.delta.w

                        distance = Math.sqrt(w*w + h*h)
                        if h >= w
                            distance *= -1
                        else
                            distance *= 1
                        value = verts[@activeVertices[0]].position.z + distance * 0.05
                        value = Math.round(value*1000)/1000
                        @prefs.set
                            float_value: parseInt(value,10)

                        return value
            
            mouseUp:=>
            
            #### *prefChange()* method takes one argument  
            # This method updates options controls to reflect user interaction  
            # `@moveExtrudedFaces()` is fired 
            prefChange:(prefModel)=>
                #console.log @prefs.float_value
                $(".float_value").val(@prefs.get('float_value'))
                $(".bool_side").attr('checked',@prefs.get('bool_side'))
                $(".float_angle").val(@prefs.get('float_angle'))

                @moveExtrudedFaces()
            
            #### *prefChange()* method takes one argument  
            # This method updates options controls to reflect user interaction  
            # `@moveExtrudedFaces()` is fired 
            moveExtrudedFaces:()=>
                ammount = parseFloat(@prefs.get('float_value'))
                angle = @prefs.get('float_angle')

                if angle != 0
                    angleDelta = Math.sin(Math.toRadian(angle))*ammount*-1

                if @activeVertices?.length? and @activeVertices?.length >0
                    verts = @activeObj.mesh.geometry.vertices
                    firstPoint = undefined
                    bool_side = @prefs.get('bool_side')
                    l=1
                    halfLength=verts.length/(@activeObj.steps+1)
                    for vertex,i in verts
                        compute = false
                        unless @activeVertices.indexOf(i.toString()) == -1
                            vertex.position.z = ammount
                            compute = true
                        unless @inactiveVertices.indexOf(i.toString()) == -1
                            if bool_side
                                vertex.position.z = -ammount
                                #compute = true
                            else
                                vertex.position.z = 0
                        if angleDelta? and compute
                            if i>=halfLength*l and i<halfLength*(l+1)
                                vertex.position.x = verts[i-halfLength*l].position.x
                                vertex.position.y = verts[i-halfLength*l].position.y
                            else if i >=halfLength*(l+1)
                                l++
                                vertex.position.x = verts[i-halfLength*l].position.x
                                vertex.position.y = verts[i-halfLength*l].position.y

                            multiplier = new THREE.Vector3()
                            for idx in vertex.faces
                                face = @activeObj.mesh.geometry.faces[idx]
                                unless face.normal.z == 1 or face.normal.z == -1 
                                    unless face.originalNormal?
                                        face.originalNormal = face.normal.clone()
                                    unless multiplier.x == face.originalNormal.x and multiplier.y == face.originalNormal.y and multiplier.z == face.originalNormal.z
                                        multiplier.addSelf(face.originalNormal)
                            vertex.position.addSelf(multiplier.multiplyScalar(angleDelta))

                    if verts[0].position.z < verts[@activeVertices[0]].position.z then @activeObj.mesh.flipSided = false else @activeObj.mesh.flipSided = true
                    @activeObj.update()

        # Singleton
        new Extrude()

)
