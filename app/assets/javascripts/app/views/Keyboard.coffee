
define(
    "views/Keyboard",
    ()->
        
        ###
        # Keyboard Class #

        Keyboard Class is used to filter keyboard events such as keyup o keydown and present them in a meaningfull way to the system
        ###

        class CC.views.Keyboard extends Spine.Module 
            @extend(Spine.Events)

            constructor:->
                @_keys = {}

                $(window).bind( 'keydown', (event)=>
                    @keyDown(event.keyCode)
                )

                $(window).bind( 'keyup', (event)=>
                    @keyUp(event.keyCode)
                )
                window.keyboard = this

            keyDown:(keyCode)=>
                #console.log keyCode
                @_keys[keyCode] = true
                Spine.trigger 'keyboard:' + keyCode + '_down'

            keyUp:(keyCode)=>
                @_keys[keyCode] = false
                Spine.trigger 'keyboard:' + keyCode + '_up'

            isKeyDown:(keyCode)=>
                if typeof keyCode == "string"
                    keyCode = @keycodeForKey(keyCode)
                unless typeof @_keys[keyCode] == "undefined"
                    return @_keys[keyCode]
                else
                    false

            isKeyUp:(keyCode)=>
                if typeof keyCode == "string"
                    keyCode = @keycodeForKey(keyCode)
                unless typeof @_keys[keyCode] == "undefined"
                    return !@_keys[keyCode]
                else
                    true

            keycodeForKey:(str)=>
                return 8 if str == "backspace"
                return 46 if str == "canc"
                return 27 if str == "esc"

                return 9 if str == "tab"

                return 16 if str == "shift"
                return 17 if str == "ctrl"
                return 18 if str == "alt"

                return 91 if str == "lcmd"
                return 93 if str == "rcmd"

                return 32 if str == "spacebar"
                return 13 if str == "return" or str == "enter"

                return 37 if str == "left"
                return 38 if str == "up"
                return 39 if str == "rigth"
                return 40 if str == "down"

            isAnyDown:=>
                result = false
                for key,value of @_keys
                    if value is true
                        result = true
                return result


)
