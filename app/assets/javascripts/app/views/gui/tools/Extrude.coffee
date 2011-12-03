define(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Extrude extends AbstractTool

            constructor:->
                super()
                @icon = "layer-resize-replicate-vertical.png"

        # Singleton
        tool = new Extrude()
        CC.views.gui.tools[tool.class] = tool
)