### Mouse Class###
# Mouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
S.export(
    "views/Mouse",
    ["views/MouseButton", "views/MouseWheel", "views/Abstract"],
    (MouseButton, MouseWheel, Abstract)->

        class Mouse extends Abstract
            #### *constructor(`@canvas`)* method takes one argument
            #* the *canvas* that contains the render and in wich events are positioned
            #
            # `@currentPos` object is created to contain `x` and `y` in pixel position form canvas top-left corner
            # and `stage3Dx` and `srage3Dy` in 0.0 to 1.0 position form canvas center  
            # [`MouseButton`](MouseButton.html) instances are created  
            # [`MouseWheel`](MouseButton.html) is created  
            # `contextmenu`, `mousemove`,`mousedown`,`mouseup` and `mousewheel` events are linked to the related methods using jQuery  

            constructor:(@canvas)->
                @currentPos = {
                    x:0
                    y:0
                    stage3Dx:0
                    stage3Dy:0
                }

                @btn1 = new MouseButton()
                @btn2 = new MouseButton()
                @btn3 = new MouseButton()
                @wheel = new MouseWheel()
                @anyDown = false

                #Mouse Events
                @canvas
                    .bind('contextmenu', (event)=>
                        event.preventDefault()
                    )
                    .bind('mousemove', (event) =>
                        @mouseMove(event)
                    )
                    .bind('mousedown', (event)=>
                        @mouseDown(event)
                    )
                    .bind('mouseup', (event)=>
                        @mouseUp(event)
                    )
                    .bind('mousewheel', (event,delta)=>
                        event.preventDefault()
                        @mouseWheel(event,delta)
                    )

                #Touch Events
                #touchCanvas = @canvas.Touchable()
                #touchCanvas.bind( 'touchablemove', (event) =>
                #    @mouseMove(event)
                #)
                #touchCanvas.bind( 'tap', ( event )=>
                #    @mouseDown(event)
                #)
                #touchCanvas.bind( 'touchableend', (event)=>
                #    @mouseUp(event)
                #)

                
            #### *mouseDown(`event`)* method takes one argument
            #* the *event* on the screen where the events was fired
            #
            # it changes the down state of the proper button and updates the `start` point of the `btn`  
            # the related `Backbone Event` is also fired
            mouseDown:(event)=>
                
                buttonNr = event.button

                if buttonNr == 0                          #click sinistro
                    @btn1.down = true
                    @btn1.start = @eventToPoint(event)
                    @anyDown =true
                    @canvas.trigger 'mouse:btn1_down'

                if buttonNr == 1                          #click centrale
                    @btn2.down = true
                    @btn2.start = @eventToPoint(event)
                    @anyDown =true
                    @canvas.trigger 'mouse:btn2_down'

                if buttonNr == 2                          #click destro
                    @btn3.down = true
                    @btn3.start = @eventToPoint(event)
                    @anyDown =true
                    @canvas.trigger 'mouse:btn3_down'

            #### *mouseMove(`event`)* method takes one argument
            #* the *event* on the screen where the events was fired
            #
            # it updates the `@currentPos` of the mouse  
            # if a mouse button is pressed `@mouseDragged` is called and the related `Backbone Event` is fired
            mouseMove:( event )=>
                @currentPos = {
                    x:@eventToPoint(event).x
                    y:@eventToPoint(event).y
                    stage3Dx:(@eventToPoint(event).x / @canvas.width()) * 2 - 1
                    stage3Dy:-(@eventToPoint(event).y / @canvas.height()) * 2 + 1
                }

                if @btn1.down
                    @mouseDragged(@eventToPoint(event),@btn1)
                    @canvas.trigger 'mouse:btn1_drag'

                if @btn2.down
                    @mouseDragged(@eventToPoint(event),@btn2)
                    @canvas.trigger 'mouse:btn2_drag'

                if @btn3.down
                    @mouseDragged(@eventToPoint(event),@btn3)
                    @canvas.trigger 'mouse:btn3_drag'

            #### *mouseDragged(`point`,`btn`)* method takes two arguments
            #* the *point* on the screen where the events was fired
            #* the *btn* instance wich was pushed
            #
            # it updates `delta` property of the proper `btn` while the mouse is beeing dragged  
            # it updates the `absoluteDelta` propery usefull for 3d rotation  
            # it updates `currentPos` of the mouse  
            mouseDragged:(point, btn)=>
                btn.absoluteDelta = {
                    w:btn.oldDelta.w + @eventToPoint(event).x - btn.start.x
                    h:btn.oldDelta.h + @eventToPoint(event).y - btn.start.y
                }
                btn.delta = {
                    w:@eventToPoint(event).x - btn.start.x
                    h:@eventToPoint(event).y - btn.start.y
                }

            #### *mouseUp(`event`)* method takes one argument
            #* the *event* on the screen where the events was fired
            #
            # it changes the down state of the proper button  
            # it updates `oldDelta` property of `btn` when it's released  
            # it updates `end` property of `btn` when it's released  
            # the related `Backbone Event` is also fired
            mouseUp:( event )=>
                buttonNr = event.button

                if buttonNr == 0 && @btn1.down
                    @btn1.down =false
                    @btn1.oldDelta = @btn1.absoluteDelta
                    @btn1.end = @eventToPoint(event)
                    @canvas.trigger 'mouse:btn1_up'

                if buttonNr == 1 && @btn2.down
                    @btn2.down =false
                    @btn2.oldDelta = @btn2.absoluteDelta
                    @btn2.end = @eventToPoint(event)
                    @canvas.trigger 'mouse:btn2_up'

                if buttonNr == 2 && @btn3.down
                    @btn3.down =false
                    @btn3.oldDelta = @btn3.absoluteDelta
                    @btn3.end = @eventToPoint(event)
                    @canvas.trigger 'mouse:btn3_up'

                if !@btn1.down && !@btn2.down && !@btn1.down
                    @anyDown =false

            #### *mouseWheel(`event`,`delta`)* method takes two arguments
            #* the *event* on the screen where the events was fired
            #* the *delta* of how much thw mouse wheel was spinned
            #
            # the related `Backbone Event` is also fired
            mouseWheel:(event,delta)->
                @wheel.direction = if delta > 0 then "UP" else "DOWN"
                @wheel.speed = Math.abs(delta)
                unless @noZoom
                    @_wheelDelta += delta/1000
                    if @_wheelDelta >1.0
                        @_wheelDelta = 1.0
                    else if @_wheelDelta <0.0
                        @_wheelDelta = 0.0
                @canvas.trigger 'mouse:wheel_changed'

            #### *eventToPoint(`event`)* method takes one argument
            #* the *event* on the screen where the events was fired
            #
            # it returns the point of the event form *page* space to *canvas* space
            eventToPoint:( event )=>
                point = {
                    x: event.pageX - @canvas.offset().left
                    y: event.pageY - @canvas.offset().top
                }
)


