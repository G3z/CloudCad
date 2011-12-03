
define(
    "views/gui/MainToolbar",
    [
        "views/gui/AbstractToolbar"
        "views/gui/tools/Select"
        "views/gui/tools/Path"
        "views/gui/tools/Extrude"
    ],
    (AbstractToolbar, Select, Path, Extrude)->
        class CC.views.gui.MainToolbar extends AbstractToolbar

            constructor:->

                html = ""
                html += Select.button()
                html += Path.button()
                html += Extrude.button()

                super(html)
                Select.do()
)