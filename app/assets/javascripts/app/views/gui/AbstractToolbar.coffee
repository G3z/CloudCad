
S.export(
    "views/gui/AbstractToolbar",
    ['views/gui/AbstractPanel'],
    (AbstractPanel)->
        class AbstractToolbar extends AbstractPanel

            ###
            Toolbar
            ###

            constructor:(html)->

                id = "toolbar_" + new Date().getTime()

                topbar = "<div class='header' id='" + id + "'>"
                topbar += "</div>"

                html = topbar + html

                super(html, id, "cc_toolbar")
)
