
S.export(
    "views/Keyboard",
    ["views/Abstract"]
    (Abstract)->
        
        ###
        # Keyboard Class #

        Keyboard Class is used to filter keyboard events such as keyup o keydown and present them in a meaningfull way to the system
        ###

        class Keyboard extends Abstract

            constructor:(@canvas)->
                @_keys = {
                    backspace:8
                    canc:46
                    esc:27
                    tab:9
                    shift:16
                    ctrl:17
                    alt:18
                    lcmd:91
                    rcmd:93
                    spacebar:32
                    enter:13
                    left:37
                    up:38
                    rigth:39
                    down:40

                    1:49
                    2:50
                    3:51
                    4:52
                    5:192           #alt + 5 on the mac = ~ :/
                    6:54
                    7:55
                    8:56
                    9:57
                    0:58

                    a:65
                    b:66
                    c:67
                    d:68
                    e:69
                    f:70
                    g:71
                    h:72
                    i:73
                    j:74
                    k:75
                    l:76
                    m:77
                    n:78
                    o:79
                    p:80
                    q:81
                    r:82
                    s:83
                    t:84
                    u:85
                    v:86
                    w:87
                    x:88
                    y:89
                    z:90

                }
                @_keysState = {}

                $(window).bind( 'keydown', (event)=>
                    @_keyDown(event.keyCode)
                )

                $(window).bind( 'keyup', (event)=>
                    @_keyUp(event.keyCode)
                )
                #window.keyboard = this

            _keyDown:(keyCode)=>
                #console.log keyCode
                @_keysState[keyCode] = true
                $(document).trigger 'keyboard:' + @keyForKeycode(keyCode) + '_down'
                $(document).trigger 'keyboard:any_down'
                return true

            _keyUp:(keyCode)=>
                @_keysState[keyCode] = false
                $(document).trigger 'keyboard:' + @keyForKeycode(keyCode) + '_up'
                $(document).trigger 'keyboard:any_up'
                return true

            isKeyDown:(keyCode)=>
                if $.type(keyCode) == "string"
                    keyCode = @keycodeForKey(keyCode)
                unless $.type(@_keysState[keyCode]) == "undefined"
                    return @_keysState[keyCode]
                else
                    false

            isKeyUp:(keyCode)=>
                if $.type(keyCode) == "string"
                    keyCode = @keycodeForKey(keyCode)
                unless $.type(@_keysState[keyCode]) == "undefined"
                    return !@_keysState[keyCode]
                else
                    true

            keycodeForKey:(key)=>
                @_keys[key]

            keyForKeycode:(keycode)=>
                for key,code of @_keys
                    if code == keycode
                        return key

            isAnyDown:=>
                result = false
                for key,value of @_keysState
                    if value is true
                        result = true
                return result


)
