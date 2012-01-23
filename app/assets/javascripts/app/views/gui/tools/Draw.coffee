### Path Tool Class###
# Path tool is used to  create planar polygons by adding one point at a time
S.export(
    "views/gui/tools/Draw",
    ["views/gui/tools/DrawTool2D","views/draw/3D/primitives/Path3D","views/draw/3D/primitives/Point3D"],
    (DrawTool2D,Path3D,Point3D)->
        class Draw extends DrawTool2D
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
                               
                # Register callback
                $(document).bind("execute_tool_Draw", =>
                    @do()
                )

        # Singleton
        new Draw()
)

