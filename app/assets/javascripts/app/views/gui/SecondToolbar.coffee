
S.export(
    "views/gui/SecondToolbar"
    [
        "solid.widgets.AbstractWidget"
        "views/gui/tools/path/Line"
        "views/gui/tools/path/Path"
    ]
    (AbstractWidget)->
                
        class SecondToolbar extends AbstractWidget
            
            constructor:->
                super()
                
                $(@el).addClass("second_toolbar")
                $(document).bind "current_tool_changed", (evt, tool)=>
                    # Empty html
                    $(@el).html("")

        new SecondToolbar()

)

