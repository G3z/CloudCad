define(
    "views/gui/tools/Extrude",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Extrude extends AbstractTool

            constructor:->
                @icon = "layer-resize-replicate-vertical.png"
                super()

        # Singleton
        tool = new Extrude()
        CC.views.gui.tools[tool.class] = tool
)