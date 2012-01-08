S.export(
    "views/Layout"
    ["solid.widgets.containers.Absolute", "views/gui/Header", "views/gui/History", "views/gui/MainToolbar", "views/gui/OptionsToolbar", "views/gui/TopBar"]
    (Absolute, Header, History, MainToolbar, OptionsToolbar, TopBar)->

        class Layout extends Absolute
            
            tagName: "div"
            className: "layout"

            constructor:(options)->
                super(options)
                @addChild(Header)
                @addChild(History)
                @addChild(OptionsToolbar)
                @addChild(MainToolbar)
                @addChild(TopBar)

                

        # Singleton
        new Layout()

)
