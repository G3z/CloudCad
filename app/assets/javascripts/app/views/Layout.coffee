S.export(
    "views/Layout"
    ["solid.widgets.containers.Absolute", "views/gui/History", "views/gui/MainToolbar", "views/gui/OptionsToolbar", "views/gui/TopBar"]
    (Absolute, History, MainToolbar, OptionsToolbar, TopBar)->

        class Layout extends Absolute

            constructor:(options)->
                super(options)
                @addChild(History)
                @addChild(OptionsToolbar)
                @addChild(MainToolbar)
                @addChild(TopBar)

        # Singleton
        new Layout()

)
