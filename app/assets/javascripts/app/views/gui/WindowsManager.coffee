
class WindowsManager extends CC.views.Abstract

    @windows

    constructor:->
        super()
        @windows = {}

    add:(id, windowElement)=>
        @windows[id] = windowElement
        $(document.body).append(windowElement)

        # Center the new window
        vW = $(window).width()
        eW = $(windowElement).width()

        $(windowElement).css('left', (vW / 2 - eW / 2) + "px");

    hide:(id)=>
        element = @windows[id]
        if element
            $(element).hide("slow")

    close:(id)=>
        element = @windows[id]
        if element
            $(element)
                .fadeOut(300, (evt)->
                    $(element).remove()
                )
            delete @windows[id]


# This class is a singleton
CC.views.gui.WindowsManager = new WindowsManager()
