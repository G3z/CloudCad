
S.export(
    "views/gui/AbstractPanel"
    ["views/Abstract", "views/gui/WindowsManager"]
    (Abstract, WindowsManager)->
        class CC.views.gui.AbstractPanel extends Abstract

            ###
            Handle windows on screen
            ###

            @element
            @mouseDown = false

            constructor:(html, id, css_class)->
                super()

                # Add toolbar

                @element = document.createElement("div")
                $(@element)
                    .addClass(css_class)
                    .html(html)

                CC.views.gui.WindowsManager.add(id, @element)

                # Add event listeners

                # Prevent the canvas behind to react
                #$(@element)
                #    .bind('mousedown', (evt)=>
                #        evt.stopImmediatePropagation()
                #        return false
                #    )
                #    .bind('mouseup', (evt)=>
                #        evt.stopImmediatePropagation()
                #        return false
                #    )



                # Handle drag and drop with the toolbar
                $("#" + id + ".header")
                    .bind('mousedown', (evt)=>
                        @mouseDown = evt
                        evt.stopImmediatePropagation()
                    )
                    .bind('mouseup', (evt)=>
                        @mouseDown = false
                        evt.stopImmediatePropagation()
                    )
                $(document.body).bind('mousemove', (evt)=>
                        if !@mouseDown then return

                        deltaX = @mouseDown.clientX - evt.clientX
                        deltaY = @mouseDown.clientY - evt.clientY
                        @mouseDown = evt

                        position = $(@element).position()
                        $(@element)
                            .css('left', position.left - deltaX)
                            .css('top', position.top - deltaY)

                        evt.stopImmediatePropagation()
                    )
        
)



