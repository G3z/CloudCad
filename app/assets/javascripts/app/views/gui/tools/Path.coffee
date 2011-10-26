
class Path extends CC.views.gui.tools.AbstractTool

    constructor:->
        super()

    render:=>
        html = "<div class='toolbarButton'>"
        html += "<img src='/fugue-icons/icons/layer-shape-polygon.png' onclick='CC.views.gui.tools.Path.do()' />"
        html += "</div>"

        return html

    do:=>
        CC.mainController.stage2d.activeTool = CC.mainController.stage2d.pathTool

# Singleton
CC.views.gui.tools.Path = new Path()
