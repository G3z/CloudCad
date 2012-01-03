
S.export(
    "views/gui/Window",
    ["views/gui/AbstractPanel"],
    (AbstractPanel)->
        class CC.views.gui.Window extends AbstractPanel

            ###
            Handle windows on screen
            ###

            constructor:(html)->

                id = "win_" + new Date().getTime()
                # Add toolbar

                toolbar = "<div class='header' id='" + id + "'>"
                toolbar += "<a href='javascript:CC.views.gui.WindowsManager.close(\"" + id + "\");' class='headerButton close'>&nbsp;</a>"
                toolbar += "<a href='javascript:CC.views.gui.WindowsManager.hide(\"" + id + "\");' class='headerButton hide'>&nbsp;<a/>"
                toolbar += "</div>"

                html = toolbar + html

                super(html, id, "cc_window")

                windowElement = $("#" + id).parent()

                # Center the new window
                vW = $(window).width()
                eW = $(windowElement).width()

                $(windowElement)
                    .css('left', (vW / 2 - eW / 2) + "px")

)

