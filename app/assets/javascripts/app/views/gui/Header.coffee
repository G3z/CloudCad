S.export(
    "views/gui/Header",
    ["solid.widgets.containers.Absolute", "views/gui/ModeSelect"],
    (Absolute, ModeSelect)->

        class Header extends Absolute

            tagName: "div"
            className: "header_bar"

            constructor:->
                super()
                @addChild(ModeSelect)
                

        new Header()
)
