
define(
    "views/gui/MainToolbar",
    ["views/gui/AbstractToolbar", "views/gui/tools/Select", "views/gui/tools/Path"],
    (AbstractToolbar, Select, Path)->
        class CC.views.gui.MainToolbar extends AbstractToolbar

            constructor:->

                html = ""
                html += CC.views.gui.tools.Select.render()
                html += CC.views.gui.tools.Path.render()

                super(html)
)