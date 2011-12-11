
define(
    "views/gui/OptionsToolbar"
    [
        "views/gui/AbstractToolbar"
    ]
    (AbstractToolbar)->
        class OptionsToolBar extends AbstractToolbar
            constructor:->
                super("")
                Spine.bind "current_tool_changed",(tool)=>

                    m = tool.getPrefModel()
                    $(@element).html("")
                    for k,v of m
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
                        dom?.attr("label",label)
                            .addClass(k)
                            .data("option_name", k)
                            .on(evtName, (evt)->
                                target = $(evt.currentTarget)
                                obj = {}
                                obj[target.data("option_name")] = target.val()
                                m.updateAttributes(obj)
                            )
                        $(@element).append(dom)
)