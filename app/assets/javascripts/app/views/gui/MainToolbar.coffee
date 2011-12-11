
define(
    "views/gui/MainToolbar",
    [
        "views/gui/AbstractToolbar"
        "views/gui/tools/Select"
        "views/gui/tools/Path"
        "views/gui/tools/Extrude"
    ],
    (AbstractToolbar, Select, Path, Extrude)->

        tools = arguments

        class MainToolbar extends AbstractToolbar

            constructor:->

                html = ""
                for k,v of tools
                    continue if k == "0"
                    html += v.button()
                

                super(html)
                Select.do()
)