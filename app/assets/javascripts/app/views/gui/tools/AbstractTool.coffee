### AbstracTool Class###
# Abstract Tool is the base class that every tool should inherit from
define(
    "views/gui/tools/AbstractTool"
    ()->
        class CC.views.gui.tools.AbstractTool
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
            # this is an utility method for subClasses.  
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


