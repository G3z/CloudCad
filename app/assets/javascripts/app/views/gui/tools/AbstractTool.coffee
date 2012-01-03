### AbstracTool Class###
# Abstract Tool is the base class that every tool should inherit from
define(
    "views/gui/tools/AbstractTool"
    ()->
        class AbstractTool
            #### *constructor()* method takes no arguments
            #
            # `@icon` propery is created to contain the default tool icon  
            # `@class` propery is created to contain the class name
            constructor:->
                @icon = "hammer.png"
                if @constructor.toString?
                    arr = @constructor.toString().match(/function\s*(\w+)/)
                    if arr? and  arr.length == 2
                        @class = arr[1]
                        @toolName = @class.toLowerCase() + "Tool"
            
            #### *button()* method takes no arguments
            #
            # this method create the button representation of the tool
            button:=>
                window.stage3d.tools[@toolName] = this
                html = "<div class='toolbarButton unselected' onclick='CC.views.gui.tools.#{@class}.do()' id='#{@toolName}'>"
                html += "<img src='/fugue-icons/icons/#{@icon}' />"
                html += "</div>"

                return html
            
            #### *do()* method takes no arguments
            #
            # this method deactivates all other button icons,
            # set the current tool to active and 
            # activate the current butto icon.  
            # it also setup the `@stage3d` property to reference the stage

            do:=>
                for name,tool of window.stage3d.tools
                    id = "#"+ name
                    $(id).removeClass("selected").addClass("unselected")
                window.stage3d.activeTool = window.stage3d.tools[@toolName]
                id = "#" + @toolName
                $(id).addClass("selected").removeClass("unselected")
                @stage3d = window.stage3d
                Spine.trigger "current_tool_changed",this

            #### *getPrefModel()* method takes no arguments
            #
            # this method is called when mouse button is clicked while tool is active.
            # this method is meant to be implemented in subClasses
            getPrefModel:=>
                if @prefs?
                    @prefs.bind "update", @prefChange
                    return @prefs

            #### *mouseDown()* method takes no arguments
            #
            # this method is called when mouse button is clicked while tool is active.
            # this method is meant to be implemented in subClasses
            mouseDown:=>
            
            #### *mouseDragged()* method takes no arguments
            #
            # this method is called when mousebutton is pressed and the mouse is moving while tool is active.
            # this method is meant to be implemented in subClasses
            mouseDragged:=>

            #### *mouseUp()* method takes no arguments
            #
            # this method is called when mouse button is released while tool is active.
            # this method is meant to be implemented in subClasses
            mouseUp:=>
            
            #### *getMouseTarget(`object`)* method takes one arguments
            #* the *object* in witch the tool should be searching for collisions
            #
            # this method retuns the first object, child of `object`, under mouse position, either in perspective or orthographic mode
            # if `object` is an array eache element is parsed until the first collision is found
            # this is an utility method for subClasses.  
            getMouseTarget:(object)=>  
                getTarget = (object)=>
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
                if $.type(object) == "array"
                    for obj in object
                        result = getTarget(obj)
                        if result?.length > 0
                            return result
                else
                    return getTarget(object)

            getBarycenter:(array)=>
                maxX=null
                maxY=null
                maxZ=null

                minX=null
                minY=null
                minZ=null
                for point in array
                    unless point.position?
                        maxX = point.x if point.x > maxX or maxX == null
                        maxY = point.y if point.y > maxY or maxY == null
                        maxZ = point.z if point.z > maxZ or maxZ == null
                        minX = point.x if point.x < minX or minX == null
                        minY = point.y if point.y < minY or minY == null
                        minZ = point.z if point.z < minZ or minZ == null
                    else
                        maxX = point.position.x if point.position.x > maxX or maxX == null
                        maxY = point.position.y if point.position.y > maxY or maxY == null
                        maxZ = point.position.z if point.position.z > maxZ or maxZ == null
                        minX = point.position.x if point.position.x < minX or minX == null
                        minY = point.position.y if point.position.y < minY or minY == null
                        minZ = point.position.z if point.position.z < minZ or minZ == null
                finalX = (minX+maxX)/2
                finalY = (minY+maxY)/2
                finalZ = (minZ+maxZ)/2
                return new THREE.Vector3(finalX,finalY,finalZ)


)


