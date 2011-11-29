
define(
    "views/gui/MainToolbar",
    ["views/gui/AbstractToolbar", "views/gui/tools/Select", "views/gui/tools/Path"],
    (AbstractToolbar, Select, Path)->
        class CC.views.gui.MainToolbar extends AbstractToolbar

            constructor:->

                html = ""
                html += Select.render()
                html += Path.render()

                super(html)
)