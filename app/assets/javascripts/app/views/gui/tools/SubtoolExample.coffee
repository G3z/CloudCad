S.export(
    "views/gui/tools/SubtoolExample",
    ["views/gui/tools/AbstractTool"],
    (AbstractTool)->
        class SubtoolExample extends AbstractTool

            constructor:->
                super()
                @icon = "cursor.png"
                @SM = {} #Selected Mesh
                
                # Register callback
                $(document)
                    .bind("execute_tool_SubtoolExample", =>
                        @do()
                    )
                    .bind("current_tool_changed", (evt, tool)=>
                        
                        if tool.toolName == "extrudeTool"
                            self = this
                            _.delay(()->
                            
                                S.import(["views/gui/SecondToolbar"], (SecondToolbar)->
                                    $(SecondToolbar.el).append($(self.button()))
                                )
                            , 50) # Mi assicuro che arrivi dopo lo svuotamento
                                
                    )

            do:=>
                super()
                alert("Hello World")

        # Singleton
        new SubtoolExample()
)
