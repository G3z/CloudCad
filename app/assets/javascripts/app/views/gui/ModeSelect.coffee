S.export(
    "views/gui/ModeSelect",
    ["solid.widgets.containers.Absolute", "solid.widgets.Select"],
    (Absolute, Select)->

        class ModeSelect extends Absolute

            tagName: "div"
            className: "mode_select"

            constructor:(options)->
                super()
                @data = ["2d draw", "3d draw", "Assembly"]

            render:=>
                super()
                @select = new Select({
                    data: @data
                }) 
                @addChild(@select)


        # Singleton
        new ModeSelect()
)
