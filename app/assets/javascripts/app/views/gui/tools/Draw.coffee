### Path Tool Class###
# Path tool is used to  create planar polygons by adding one point at a time
S.export(
    "views/gui/tools/Draw",
    ["views/gui/tools/AbstractTool","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (AbstractTool,Path3D,Point3D)->
        class Draw extends AbstractTool
            #### *constructor()* method takes no arguments
            #
            # `@icon` propery is overridden to contain the tool icon  
            # `@activePlane` propery is initialized to contain the plane on which the path is drawn
            # `@activePath` propery is initialized to contain the path in creation
            # `@activePoint` propery is initialized to contain the last active point (moved or added)
            # `execute_tool_Path` event is registered to fire `@do()`
            constructor:->
                super()
                @icon = "pencil.png"
                @activePoint = null
                @activePlane = null
                @activePath = null
                
                # Register callback
                $(document).bind("execute_tool_Draw", =>
                    @do()
                )
                
            #### *do()* method takes no arguments 
            # `@activePlane` propery is reset to null
            # `@activePath` propery is reset to null
            # `@activePoint` propery is reset to null
            do:=>
                super()
                @activePoint = null
                @activePlane = null
                @activePath = null
            
            #### *mouseDown()* method takes no arguments 
            # it checks if there is already an `@activePlane` otherwise the one under mouse cursor is selectedObject
            # if an `@activePlane` is present a new contact point on the plane is discovered and it is 
            mouseDown:=>

            
            mouseDragged:=>
                
            
            mouseUp:=>

        # Singleton
        new Draw()
)

