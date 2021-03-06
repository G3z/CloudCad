S.export(
    "views/Layout"
    [
        "solid.widgets.containers.Absolute",
        "views/gui/Header",
        "views/gui/History",
        "views/gui/TopBar",
        "views/draw/3D/Stage3d",
        "views/gui/MainToolbar"
    ]
    (Absolute, Header, History, TopBar, Stage3d, MainToolbar)->

        class Layout extends Absolute
            
            tagName: "div"
            className: "layout"

            constructor:(options)->
                super(options)
                @addChild(Header)
                
                @addChild(TopBar)
                @addChild(Stage3d)
                Stage3d.startLoops()
                
                @addChild(MainToolbar)
                @addChild(History)
                
                # Posizioning History Menu
                $(History.el).css("left", ($(document).width() - 200) + "px")

        # Singleton
        new Layout()

)
