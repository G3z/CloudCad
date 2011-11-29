define(
    "views/gui/tools/Path",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Path extends AbstractTool

            constructor:->
                super()

            render:=>
                html = "<div class='toolbarButton'>"
                html += "<img src='/fugue-icons/icons/layer-shape-polygon.png' onclick='CC.views.gui.tools.Path.do()' />"
                html += "</div>"

                return html

            do:=>
                CC.mainController.stage3d.activeTool = CC.mainController.stage3d.pathTool

        # Singleton
        CC.views.gui.tools.Path = new Path()
)

