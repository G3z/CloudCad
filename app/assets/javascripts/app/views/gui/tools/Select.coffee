
class Select extends CC.views.gui.tools.AbstractTool

    constructor:->
        super()

    render:=>
        html = "<div class='toolbarButton'>"
        html += "<img src='/fugue-icons/icons/cursor.png' onclick='CC.views.gui.tools.Select.do()' />"
        html += "</div>"

        return html

    do:=>
        console.log("TEST")

# Singleton
CC.views.gui.tools.Select = new Select()
