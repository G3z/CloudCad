###
# Mouse Class#

Mouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###

class CC.views.draw.Mouse extends CC.views.draw.ThreeMouse 
    
    ###
        When this class is created it disables right-mouse context menu so that it's possible to use that mouse button
    ###

    constructor:(camera,domElement)->
        super(camera,domElement)

    keyDown:( event )=>
        super(event)

    keyUp:( event )=>
        super(event)

    mouseDown:( event )=>
        super(event)

    mouseMove:( event )=>
        super(event)

    mouseUp:( event )=>
        super(event)

