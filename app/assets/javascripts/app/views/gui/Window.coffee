
class CC.views.gui.Window extends CC.views.gui.AbstractWindow

    ###
    Handle windows on screen
    ###

    constructor:(html)->

        id = "win_" + new Date().getTime()
        # Add toolbar

        toolbar = "<div class='header' id='" + id + "'>"
        toolbar += "<a href='javascript:CC.views.gui.WindowsManager.close(\"" + id + "\");' class='headerButton close'>&nbsp;</a>"
        toolbar += "<a href='javascript:CC.views.gui.WindowsManager.hide(\"" + id + "\");' class='headerButton hide'>&nbsp;<a/>"
        toolbar += "</div>";

        html = toolbar + html

        super(html, id, "cc_window")


