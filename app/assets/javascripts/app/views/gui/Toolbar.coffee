
class CC.views.gui.Toolbar extends CC.views.gui.AbstractWindow

    ###
    Toolbar
    ###


    constructor:(html)->

        id = "toolbar_" + new Date().getTime()

        html = html

        super(html, id, "cc_toolbar")

