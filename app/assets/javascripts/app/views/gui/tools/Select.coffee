S.export(
    "views/gui/tools/Select",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Select extends AbstractTool

            constructor:->
                super()
                @icon = "cursor.png"
                @SM = {} #Selected Mesh
                
                # Register callback
                $(document).bind("execute_tool_Select", =>
                    @do()
                )

            do:=>
                super()
                if @stage3d.selectedObject?
                    @stage3d.selectedObject.toggleSelection()
                    @stage3d.selectedObject = undefined

            mouseDown:()=>
                c = @getMouseTarget([@stage3d.layers.solids,@stage3d.layers.paths,@stage3d.layers.planes])
                if c? and c.length>0
                    if c[0].object?
                        obj = c[0].object
                        if @stage3d.selectedObject? and @stage3d.selectedObject.id != obj.father?.id?
                            unless @stage3d.selectedObject.class == "Plane3D"
                                @stage3d.selectedObject.toggleSelection()
                        if obj.father?
                            unless obj.father.class == "Plane3D"
                                obj.father.toggleSelection()
                        @stage3d.selectedObject = obj.father

            mouseDragged:()=>


            mouseUp:()=>

        # Singleton
        new Select()
)
