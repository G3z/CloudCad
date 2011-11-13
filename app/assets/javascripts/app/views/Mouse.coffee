###
# Mouse Class #

Mouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###

class CC.views.Mouse extends Spine.Module
    
    ###
        When this class is created it disables right-mouse context menu so that it's possible to use that mouse button
    ###

    constructor:(@domElement)->
        @currentPos = {
            x:0
            y:0
            stage3Dx:0
            stage3Dy:0
        }

        @btn1 = new CC.views.MouseButton()
        @btn2 = new CC.views.MouseButton()
        @btn3 = new CC.views.MouseButton()
        @wheel = new CC.views.MouseWheel()
        @anyDown = false

        @domElement.bind('contextmenu', ( event )=>
            event.preventDefault()
        )

        @domElement.bind( 'mousemove', (event) =>
            @mouseMove(event)
        )

        @domElement.bind( 'mousedown', ( event )=>
            @mouseDown(event)
        )

        @domElement.bind( 'mouseup', (event)=>
            @mouseUp(event)
        )

        @domElement.bind('mousewheel', (event,delta)=>
            event.preventDefault()
            @mouseWheel(event,delta)
        )

    mouseDown:( event )=>
        ###
            *mouseDown* method takes two arguments
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it changes the down state of the proper button and updates the start point of the event
        ###
        buttonNr = event.button

        if buttonNr == 0                          #click sinistro
            @btn1.down = true
            @btn1.start = @eventToPoint(event)
            @anyDown =true
            Spine.trigger 'mouse:btn1_down'

        if buttonNr == 1                          #click centrale
            @btn2.down = true
            @btn2.start = @eventToPoint(event)
            @anyDown =true
            Spine.trigger 'mouse:btn2_down'

        if buttonNr == 2                          #click destro
            @btn3.down = true
            @btn3.start = @eventToPoint(event)
            @anyDown =true
            Spine.trigger 'mouse:btn3_down'

    mouseMove:( event )=>
        ###
            *mouseMove* method takes one argument
            #the *point* on the screen where the mouse is
            it updates currentPos of the mouse
            if any button is pushed, mouseDragged is called
        ###
        @currentPos = {
            x:@eventToPoint(event).x
            y:@eventToPoint(event).y
            stage3Dx:(@eventToPoint(event).x / @domElement.width()) * 2 - 1
            stage3Dy:-(@eventToPoint(event).y / @domElement.height()) * 2 + 1
        }
        #console.log(@currentPos.stage3Dx, @currentPos.stage3Dy)

        if @btn1.down
            @mouseDragged(@eventToPoint(event),@btn1)
            Spine.trigger 'mouse:btn1_drag'

        if @btn2.down
            @mouseDragged(@eventToPoint(event),@btn2)
            Spine.trigger 'mouse:btn2_drag'

        if @btn3.down
            @mouseDragged(@eventToPoint(event),@btn3)
            Spine.trigger 'mouse:btn3_drag'

    mouseDragged:(point,btn)=>
        ###
            *mouseDragged* method takes two arguments
            #the *point* on the screen where the events was fired
            #the *btn* instance wich was pushed
            it updates delta property of the proper btn while the mouse is beeing dragged
            it updates the absoluteDelta propery usefull for 3d rotation
            it updates currentPos of the mouse
        ###

        btn.absoluteDelta = {
            w:btn.oldDelta.w + @eventToPoint(event).x - btn.start.x
            h:btn.oldDelta.h + @eventToPoint(event).y - btn.start.y
        }
        btn.delta = {
            w:@eventToPoint(event).x - btn.start.x
            h:@eventToPoint(event).y - btn.start.y
        }

    mouseUp:( event )=>
        ###
            *mouseUp* method takes two arguments
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it updates oldDelta property of btn when it's released
            it updates end property of btn when it's released
        ###
        buttonNr = event.button

        if buttonNr == 0 && @btn1.down
            @btn1.down =false
            @btn1.oldDelta = @btn1.absoluteDelta
            @btn1.end = @eventToPoint(event)
            Spine.trigger 'mouse:btn1_up'

        if buttonNr == 1 && @btn2.down
            @btn2.down =false
            @btn2.oldDelta = @btn2.absoluteDelta
            @btn2.end = @eventToPoint(event)
            Spine.trigger 'mouse:btn2_up'

        if buttonNr == 2 && @btn3.down
            @btn3.down =false
            @btn3.oldDelta = @btn3.absoluteDelta
            @btn3.end = @eventToPoint(event)
            Spine.trigger 'mouse:btn3_up'

        if !@btn1.down && !@btn2.down && !@btn1.down
            @anyDown =false
    
    mouseWheel:(event,delta)->
        Spine.trigger 'mouse:wheel_changed'

    eventToPoint:( event )=>
        point = {
            x: event.pageX - @domElement.offset().left
            y: event.pageY - @domElement.offset().top
        }

