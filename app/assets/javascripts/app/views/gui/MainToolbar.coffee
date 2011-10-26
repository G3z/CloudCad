
class CC.views.gui.MainToolbar extends CC.views.gui.AbstractToolbar

    constructor:->

        html = ""
        html += CC.views.gui.tools.Select.render()
        html += CC.views.gui.tools.Path.render()

        super(html)
