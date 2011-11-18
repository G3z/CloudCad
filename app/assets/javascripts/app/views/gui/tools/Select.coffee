define(
    "views/gui/tools/Select",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class Select extends AbstractTool

            constructor:->
                super()

            render:=>
                html = "<div class='toolbarButton'>"
                html += "<img src='/fugue-icons/icons/cursor.png' onclick='CC.views.gui.tools.Select.do()' />"
                html += "</div>"

                return html

            do:=>
                CC.mainController.stage2d.activeTool = CC.mainController.stage2d.selectTool

        # Singleton
        CC.views.gui.tools.Select = new Select()
)