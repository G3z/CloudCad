
define(
    "views/gui/tools/AbstractTool"
    ()->
        class CC.views.gui.tools.AbstractTool

            constructor:->
                @getClass()
            
            ##ToolBar Configuration
            render:=>
                window.stage3d[@toolName()] = this
                html = "<div class='toolbarButton'>"
                html += "<img src='/fugue-icons/icons/#{@icon}' onclick='CC.views.gui.tools.#{@class}.do()' />"
                html += "</div>"

                return html

            do:=>
                window.stage3d.activeTool = window.stage3d[@toolName()]
                @stage3d = window.stage3d
                @path = @stage3d.activePath
                @active = false
                return
            
            toolName:=>
                lower_class = @class.toLowerCase()
                lower_class += "Tool"

            getClass:=>
                if @constructor.toString?
                    arr = @constructor.toString().match(/function\s*(\w+)/)
                    if arr? and  arr.length == 2
                        @class = arr[1]
                        return @class

                return undefined
            
            #stage Methods

            mouseDown:()=>
                
            mouseDragged:()=>

            mouseUp:()=>

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


