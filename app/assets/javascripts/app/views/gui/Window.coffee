
class CC.views.gui.Window extends CC.views.Abstract

    ###
    Handle windows on screen
    ###

    @element
    @mouseDown = false

    constructor:(html)->
        super()

        id = "win_" + new Date().getTime()
        # Add toolbar
        toolbar = "<div class='toolbar' id='" + id + "'>"
        toolbar += "<a href='javascript:CC.views.gui.WindowsManager.close(\"" + id + "\");' class='toolbarButton close'>"
        toolbar += "<a href='javascript:CC.views.gui.WindowsManager.hide(\"" + id + "\");' class='toolbarButton hide'>"
        toolbar += "</div>";

        html = toolbar + html

        @element = document.createElement("div")
        $(@element)
            .addClass("cc_window")
            .html(html)

        CC.views.gui.WindowsManager.add(id, @element)

        # Add event listeners
        $("#" + id + ".toolbar")
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

#                console.log(deltaX + " - " + deltaY)

                position = $(@element).position()
                $(@element)
                    .css('left', position.left - deltaX)
                    .css('top', position.top - deltaY)

                evt.stopImmediatePropagation()
            )


