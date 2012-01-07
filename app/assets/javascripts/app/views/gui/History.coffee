S.export(
    "views/gui/History",
    ["solid.widgets.AbstractWidget", "solid.widgets.containers.HBox"],
    (AbstractWidget, HBox)->

        class History extends AbstractWidget

            constructor:(options)->
                super(options)
                @list = new HBox()

        # Singleton
        new History()
)
