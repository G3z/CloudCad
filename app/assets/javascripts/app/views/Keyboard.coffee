###
# Keyboard Class #

Keyboard Class is used to filter keyboard events such as keyup o keydown and present them in a meaningfull way to the system
###

class CC.views.Keyboard extends Spine.Module 
    @extend(Spine.Events)

    constructor:()->
        @_keys = {}
        
        $(window).bind( 'keydown', (event)=>
            @keyDown(event.keyCode)
        )

        $(window).bind( 'keyup', (event)=>
            @keyUp(event.keyCode)
        )
    
    keyDown:(keyCode)=>
        @_keys[keyCode] = true
        Spine.trigger 'keyboard:' + keyCode + '_down'

    keyUp:(keyCode)=>
        @_keys[keyCode] = false
        Spine.trigger 'keyboard:' + keyCode + '_up'
    
    isKeyDown:(keyCode)=>
        @_keys[keyCode]

    isKeyUp:(keyCode)=>
        !@_keys[keyCode]