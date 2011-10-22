###
# Mouse Class#

Mouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###

class CC.views.draw.Mouse extends Spine.Module
    @extend(Spine.Events)
    ###
        When this class is created it disables right-mouse context menu so that it's possible to use that mouse button
    ###
    constructor:->
        @currentPos = {
            x:0
            y:0
        }
        @btn1 = new CC.views.draw.MouseButton()
        @btn2 = new CC.views.draw.MouseButton()
        @btn3 = new CC.views.draw.MouseButton()

        $(document.body).attr("oncontextmenu","return false")
        $(document).mousedown( (event)=> @mouseDown({x:event.clientX,y:event.clientY},event.which))

        $(document).mousemove( (event)=> @mouseMoved({x:event.clientX,y:event.clientY}) )

        $(document).mouseup( (event)=>  @mouseUp({x:event.clientX,y:event.clientY},event.which))

    mouseDown:(point,buttonNr)->
        ###
            *mouseDown* method takes two arguments 
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it changes the down state of the proper button and updates the start point of the event
        ###
        if buttonNr == 1                          #click sinistro
            @btn1.down = true
            @btn1.start = point
            Spine.trigger 'mouse:btn1_down'

        if buttonNr == 2                          #click centrale
            @btn2.down = true
            @btn2.start = point
            Spine.trigger 'mouse:btn2_down'

        if buttonNr == 3                          #click centrale
            @btn3.down = true
            @btn3.start = point
            Spine.trigger 'mouse:btn3_down'
        

    mouseMoved:(point)=>
        ###
            *mouseMove* method takes one argument 
            #the *point* on the screen where the mouse is
            it updates currentPos of the mouse
            if any button is pushed, mouseDragged is called
        ###
        @currentPos = point
        if @btn1.down
            @mouseDragged(point,@btn1)
            Spine.trigger 'mouse:btn1_drag'
        if @btn2.down
            @mouseDragged(point,@btn2)
            Spine.trigger 'mouse:btn2_drag'
        if @btn3.down
            @mouseDragged(point,@btn3)
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
            w:btn.oldDelta.w + point.x - btn.start.x
            h:btn.oldDelta.h + point.y - btn.start.y
        }
        btn.delta = {
            w:point.x - btn.start.x
            h:point.y - btn.start.y
        }

    mouseUp:(point,buttonNr)->
        ###
            *mouseUp* method takes two arguments 
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it updates oldDelta property of btn when it's released
            it updates end property of btn when it's released
        ###
        if buttonNr == 1 && @btn1.down
            @btn1.down =false
            @btn1.oldDelta = @btn1.absoluteDelta
            @btn1.end = point
            Spine.trigger 'mouse:btn1_up'

        if buttonNr == 2 && @btn2.down
            @btn2.down =false
            @btn2.oldDelta = @btn2.absoluteDelta
            @btn2.end = point
            Spine.trigger 'mouse:btn2_up'

        if buttonNr == 3 && @btn3.down
            @btn3.down =false
            @btn3.oldDelta = @btn3.absoluteDelta
            @btn3.end = point
            Spine.trigger 'mouse:btn3_up'

        