###
# Mouse Class#

Mouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###

class CC.views.draw.Mouse
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

        $(document).mousemove( (event)=> @mouseDragged({x:event.clientX,y:event.clientY},event.which) )

        $(document).mouseup( (event)=>  @mouseUp({x:event.clientX,y:event.clientY},event.which))

    mouseDown:(point,button)->
        ###
            *mouseDown* method takes two arguments 
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it changes the down state of the proper button and updates the start point of the event
        ###
        if button == 1                          #click sinistro
            @btn1.down = true
            @btn1.start = point

        if button == 2                          #click centrale
            @btn2.down = true
            @btn2.start = point

        if button == 3                          #click centrale
            @btn3.down = true
            @btn3.start = point
        

    mouseDragged:(point,button)=>
        ###
            *mouseDragged* method takes two arguments 
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it updates delta property of the proper btn while the mouse is beeing dragged
            it updates the absoluteDelta propery usefull for 3d rotation
            it updates currentPos of the mouse
        ###
        if button ==1 && @btn1.down
            @btn1.absoluteDelta = {
                w:@btn1.oldDelta.w + point.x - @btn1.start.x
                h:@btn1.oldDelta.h + point.y - @btn1.start.y
            }
            @btn1.delta = {
                w:point.x - @btn1.start.x
                h:point.y - @btn1.start.y
            }

        if button ==2 && @btn2.down
            @btn2.absoluteDelta = {
                w:@btn2.oldDelta.w + point.x - @btn2.start.x
                h:@btn2.oldDelta.h + point.y - @btn2.start.y
            }
            @btn2.delta = {
                w:point.x - @btn2.start.x
                h:point.y - @btn2.start.y
            }

        if button ==3 && @btn3.down
            @btn3.absoluteDelta = {
                w:@btn3.oldDelta.w + point.x - @btn3.start.x
                h:@btn3.oldDelta.h + point.y - @btn3.start.y
            }
            @btn3.delta = {
                w:point.x - @btn3.start.x
                h:point.y - @btn3.start.y
            }
        @currentPos = point

    mouseUp:(point,button)->
        ###
            *mouseUp* method takes two arguments 
            #the *point* on the screen where the events was fired
            #the *button* wich was pushed
            it updates oldDelta property of btn when it's released
            it updates end property of btn when it's released
        ###
        if button == 1 && @btn1.down
            @btn1.down =false
            @btn1.oldDelta = @btn1.absoluteDelta
            @btn1.end = point

        if button == 2 && @btn2.down
            @btn2.down =false
            @btn2.oldDelta = @btn2.absoluteDelta
            @btn2.end = point

        if button == 3 && @btn3.down
            @btn3.down =false
            @btn3.oldDelta = @btn3.absoluteDelta
            @btn3.end = point

        