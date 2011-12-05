define(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Extrude extends AbstractTool

            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"
            
            mouseDown:()=>
                @activeObj = @stage3d.selectedObject
                if @activeObj?.class == "Path3D"
                    @activeObj.extrude(5)

            mouseDragged:()=>

            mouseUp:()=>

        # Singleton
        tool = new Extrude()
        CC.views.gui.tools[tool.class] = tool
)