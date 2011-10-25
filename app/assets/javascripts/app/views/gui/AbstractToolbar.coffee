
class CC.views.gui.AbstractToolbar extends CC.views.gui.AbstractPanel

    ###
    Toolbar
    ###

    constructor:(html)->

        id = "toolbar_" + new Date().getTime()

        topbar = "<div class='header' id='" + id + "'>"
        topbar += "</div>"

        html = topbar + html

        super(html, id, "cc_toolbar")

