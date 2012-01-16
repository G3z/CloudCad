
S.export(
    "views/gui/MainToolbar",
    [
        "views/gui/AbstractToolbar"
        "views/gui/tools/Select"
        "views/gui/tools/Plane"
        "views/gui/tools/Draw"
        "views/gui/tools/Extrude"
    ],
    (AbstractToolbar, Select, Plane, Path, Extrude)->
        
        tools = arguments

        class MainToolbar extends AbstractToolbar
            
            constructor:->
                super()
                
                cnt = document.createElement("div")

                html = ""
                for k,v of tools
                    continue if k == "0"
                    html += v.button()
                

                $(cnt)
                    .html(html)
                    .addClass("buttons")

                $(@el)
                    .append(cnt)
                    .addClass("cc_toolbar")
                
                self = this
                
                S.import(["views/gui/SecondToolbar", "views/gui/OptionsToolbar"], (SecondToolbar, OptionsToolbar)->
                    self.addChild(SecondToolbar)
                    self.addChild(OptionsToolbar)
                )
                
                # Attivo il primo comando
                Select.do()

        # Singleton
        new MainToolbar()
)
