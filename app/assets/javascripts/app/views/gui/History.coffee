S.export(
    "views/gui/History",
    ["views/gui/AbstractToolbar", "solid.widgets.containers.HBox", "models/Actions"],
    (AbstractToolbar, HBox, Actions)->

        class History extends AbstractToolbar
            
            tagName: "div"
            className: "history"

            constructor:(options)->
                super(options)
                @data = Actions
                
                # Some graphic initializazion
                $(".header", @el).html("History")
                @list = new HBox()
                @addChild(@list)

            addAction:(action)=>
                
                # Store the action 
                @data.add(action)
                
                # Show the action in the History
                item = document.createElement('div')
                $(item)
                    .addClass("item")
                    .html(action.get("label") + "<div class='" + action.get('label') + "'></div>")

                $(@list.el).append(item)

            getLastAction:()=>
                action = @data.last()

        # Singleton
        new History()
)
