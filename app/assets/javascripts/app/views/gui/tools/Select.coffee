define(
    "views/gui/tools/Select",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Select extends AbstractTool

            constructor:->
                @icon = "cursor.png"
                @selectedIdx=null
                @SM = {} #Selected Mesh

                super()

            mouseDown:()=>
                c = @getMouseTarget(@stage3d.world)
                if c? and c.length>0
                    if c[0].object? and c[0].object != @stage3d.cameraPlane
                        obj = c[0].object
                        if @stage3d.selectedMesh? and @stage3d.selectedMesh != obj
                            @stage3d.selectedMesh.parent.material.color.setHex(@SM.oldcolor)
                        if obj.parent?
                            @SM.oldcolor = obj.parent.material.color.getHex()
                            obj.parent?.material?.color?.setHex(0x0000bb)
                        @stage3d.selectedMesh = obj
                    else
                        @stage3d.selectedMesh = null
                            

            mouseDragged:()=>


            mouseUp:()=>

        # Singleton
        tool = new Select()
        CC.views.gui.tools[tool.class] = tool
)