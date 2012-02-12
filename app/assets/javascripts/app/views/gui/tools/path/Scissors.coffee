### Line Tool Class###
# line tool is used to create planar Lines
S.export(
    "views/gui/tools/path/Scissors",
    [
        "views/gui/tools/DrawTool2D",
        "views/draw/3D/primitives/Path3D",
        "views/draw/3D/primitives/Point3D"
        "models/Action",
        "views/gui/History"
    ],
    (DrawTool2D ,Path3D, Point3D, Action, History)->
        class Scissors extends DrawTool2D

            constructor:->
                super()
                @icon = "scissors-blue.png"
                # Register callback
                $(document)
                    .bind("execute_tool_Scissors", =>
                        @do()
                    )
                    .bind("current_tool_changed", (evt, tool)=>
                        
                        if tool.toolName == "drawTool"
                            self = this
                            _.delay(()->
                            
                                S.import(["views/gui/SecondToolbar"], (SecondToolbar)->
                                    $(SecondToolbar.el).append($(self.button()))
                                )
                            , 50) # Mi assicuro che arrivi dopo lo svuotamento
                                
                    )

            mouseDown:=>                
                                
            
            mouseDragged:=>
                

            mouseUp:=>
                

        # Singleton
        new Scissors()
)
