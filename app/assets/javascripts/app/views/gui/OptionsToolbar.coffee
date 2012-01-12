
S.export(
    "views/gui/OptionsToolbar"
    ["solid.widgets.AbstractWidget"]
    (AbstractWidget)->
                
        class OptionsToolBar extends AbstractWidget
            
            constructor:->
                super()
                
                $(@el).addClass("options_panel")

                $(document).bind "current_tool_changed", (evt, tool)=>
                    
                    m = tool.getPrefModel()
                    
                    if !m
                        return

                    data = m.toJSON()
                    
                    $(@el).html("")

                    for k,v of data
                        continue if k.indexOf("_") < 0
                        parArray = k.split("_")
                        type = parArray[0]
                        label = parArray[1]
                        evtName = ""
                        if type == "bool"
                            dom = $("<input>").attr("type","checkbox")
                            evtName = "change"
                        else if type == "float"
                            dom = $("<input>").attr("type","text")
                            evtName = "keyup"
                        dom?.attr("label", label)
                            .addClass(k)
                            .data("option_name", k)
                            .on(evtName, (evt,type)->
                                target = $(evt.currentTarget)
                                obj = {}
                                if type == "bool"
                                    obj[target.data("option_name")] = target.attr("checked")
                                else
                                    obj[target.data("option_name")] = target.val()
                                m.set(obj)
                            )
    
                        label = $("<label>").html(m.getLabel(k) + ":")
                        
                        cnt = document.createElement("div")
                        $(cnt)
                            .addClass("options_container")
                            .append(label)
                            .append(dom)

                        $(@el).append(cnt)
                            

        new OptionsToolBar()

)
