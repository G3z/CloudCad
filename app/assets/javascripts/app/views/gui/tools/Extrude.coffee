S.export(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool", "views/gui/tools/ToolOption"],
    (AbstractTool, ToolOption)->

        class Extrude extends AbstractTool
            @frontFacingVertices
            @backFacingVertices
            @inactiveVertices
            #### *constructor()* method takes no arguments  
            # 
            # 
            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"

                class Pref extends ToolOption
                    # @configure "Pref", "float_value", "bool_bothSides"
                    
                @prefs = new Pref(
                    float_value: 50
                    bool_bothSides: false
                    float_angle: 0
                )
                
                # Set labels
                @prefs.setLabel("float_value", "Extrusion value")
                @prefs.setLabel("bool_bothSides", "Booth sides")
                @prefs.setLabel("float_angle", "Extrusion angle")

                # Register callback
                $(document).bind("execute_tool_Extrude", =>
                    @do()
                    $(".float_value").val(@prefs.get('float_value'))
                    $(".bool_bothSides").attr('checked',@prefs.get('bool_bothSides'))
                    $(".float_angle").val(@prefs.get('float_angle'))
                )
            
            #### *mouseDown()* method takes no arguments 
            # it checks if the active object is an instance of Path3D with more than 2 points  
            # the path is extruded and the new solid become the selectedObject  
            # `@frontFacingVertices` contains the vertex of the new face while `@backFacingVertices` contains the vertices of the base  
            # `@prefs` are reset
            mouseDown:=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D" and @activeObj.points.length > 2
                    @activeObj.extrude(@prefs.get('float_value'))
                    @activeObj = @stage3d.selectedObject
                    if @bool_bothSides
                        @activeObj.steps=2
                        @activeObj.createGeometry()
                    @frontFacingVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,1),"vertexIndices")
                    @backFacingVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,-1),"vertexIndices")
                    @inactiveVertices = []
                    if @bool_bothSides
                        for vert,i in @activeObj.mesh.geometry.vertices
                            if @frontFacingVertices.indexOf(i.toString()) == -1 and @backFacingVertices.indexOf(i.toString()) == -1
                                @inactiveVertices.push(i.toString())
                    @prefs.set
                        float_value: @prefs.get('float_value')
                        bool_bothSides: @prefs.get('bool_bothSides')
                        float_angle: @prefs.get('float_angle')
            
            #### *mouseDragged()* method takes no arguments 
            # It checks if the active object is an instance of Solid3D  
            # A new extrusion ammount is calculad based on mouse movement  
            # `@prefs.float_value` is updated with the new value of the extrusion
            mouseDragged:=>
                if @activeObj?.class == "Solid3D"
                    if @frontFacingVertices.length? and @frontFacingVertices.length >0
                        verts = @activeObj.mesh.geometry.vertices
                        h = @stage3d.mouse.btn1.delta.h
                        w = @stage3d.mouse.btn1.delta.w

                        distance = Math.sqrt(w*w + h*h)
                        if h >= w
                            distance *= -1
                        else
                            distance *= 1
                        value = verts[@frontFacingVertices[0]].position.z + distance * 0.05
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
                $(".float_angle").val(@prefs.get('float_angle'))
                
                if @prefs.hasChanged('bool_bothSides')
                    @bool_bothSides = @prefs.get('bool_bothSides')
                    $(".bool_bothSides").attr('checked',@bool_bothSides)
                    if @activeObj?
                        if @bool_bothSides
                            @activeObj.steps=2
                        else
                            @activeObj.steps=1
                        @activeObj.createGeometry()
                        @frontFacingVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,1),"vertexIndices")
                        @backFacingVertices = @activeObj.facesWithNormal(new THREE.Vector3(0,0,-1),"vertexIndices")
                        @inactiveVertices = []
                        if @bool_bothSides
                            for vert,i in @activeObj.mesh.geometry.vertices
                                if @frontFacingVertices.indexOf(i.toString()) == -1 and @backFacingVertices.indexOf(i.toString()) == -1
                                    @inactiveVertices.push(i.toString())

                @moveExtrudedFaces()
            
            #### *prefChange()* method takes one argument  
            # This method updates options controls to reflect user interaction  
            # `@moveExtrudedFaces()` is fired 
            moveExtrudedFaces:()=>
                @ammount = parseFloat(@prefs.get('float_value'))
                @angle = parseFloat(@prefs.get('float_angle'))

                if @angle != 0
                    angleDelta = Math.sin(Math.toRadian(@angle))*@ammount*-1
                else
                    angleDelta = 0

                if @frontFacingVertices?.length? and @frontFacingVertices?.length >0
                    verts = @activeObj.mesh.geometry.vertices
                    firstPoint = undefined                    
                    
                    halfLength=verts.length/(@activeObj.steps+1)
                    for vertex,i in verts
                        compute = false
                        #extrusion ammount
                        unless @frontFacingVertices.indexOf(i.toString()) == -1
                            h = @frontFacingVertices.indexOf(i.toString())
                            vertex.position.z = @ammount
                            compute = true
                        unless @backFacingVertices.indexOf(i.toString()) == -1
                            h = @backFacingVertices.indexOf(i.toString())
                            if @bool_bothSides
                                vertex.position.z = -@ammount
                                compute = true
                            else
                                vertex.position.z = 0
                        unless @inactiveVertices.indexOf(i.toString()) == -1
                            h = @inactiveVertices.indexOf(i.toString())
                            if @bool_bothSides
                                vertex.position.z = 0
                        #angle ammount
                        if angleDelta? and compute
                            if @bool_bothSides
                                vertex.position.x = verts[@inactiveVertices[h]].position.x
                                vertex.position.y = verts[@inactiveVertices[h]].position.y
                            else
                                vertex.position.x = verts[@backFacingVertices[h]].position.x
                                vertex.position.y = verts[@backFacingVertices[h]].position.y
                            ###
                            if i>=halfLength*l and i<halfLength*(l+1)
                                vertex.position.x = verts[i-halfLength*l].position.x
                                vertex.position.y = verts[i-halfLength*l].position.y
                            else if i >=halfLength*(l+1)
                                l++
                                vertex.position.x = verts[i-halfLength*l].position.x
                                vertex.position.y = verts[i-halfLength*l].position.y
                            ###
                            multiplier = new THREE.Vector3()
                            for idx in vertex.faces
                                face = @activeObj.mesh.geometry.faces[idx]
                                unless face.normal.z == 1 or face.normal.z == -1 
                                    unless face.originalNormal?
                                        face.originalNormal = face.normal.clone()
                                    unless multiplier.x == face.originalNormal.x and multiplier.y == face.originalNormal.y and multiplier.z == face.originalNormal.z
                                        multiplier.addSelf(face.originalNormal)
                            vertex.position.addSelf(multiplier.multiplyScalar(angleDelta))

                    if verts[0].position.z < verts[@frontFacingVertices[0]].position.z then @activeObj.mesh.flipSided = false else @activeObj.mesh.flipSided = true
                    @activeObj.update()

        # Singleton
        new Extrude()

)
