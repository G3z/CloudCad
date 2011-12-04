define(
    "views/gui/tools/Select",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Select extends AbstractTool

            constructor:->
                super()
                @icon = "cursor.png"
                @SM = {} #Selected Mesh

            mouseDown:()=>
                c = @getMouseTarget(@stage3d.world)
                if c? and c.length>0
                    if c[0].object? and c[0].object != @stage3d.cameraPlane
                        obj = c[0].object
                        if @stage3d.selectedObject? and @stage3d.selectedObject.id != obj.father?.id?
                            @stage3d.selectedObject.toggleSelection()
                        if obj.father?
                            obj.father.toggleSelection()
                        @stage3d.selectedObject = obj.father

            mouseDragged:()=>


            mouseUp:()=>

        # Singleton
        tool = new Select()
        CC.views.gui.tools[tool.class] = tool
)