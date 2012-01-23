S.export(
    "views/gui/History",
    ["solid.widgets.AbstractWidget", "solid.widgets.containers.HBox"],
    (AbstractWidget, HBox)->

        class History extends AbstractWidget

            constructor:(options)->
                super(options)

            render:()=>
                @list = new HBox()
                @addChild(@list)

        # Singleton
        new History()
)
