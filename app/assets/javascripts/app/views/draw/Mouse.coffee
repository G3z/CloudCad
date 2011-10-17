class CC.views.draw.Mouse
    
    constructor:->
        @rotationScale = 0.003
        @btn1 = new CC.views.draw.MouseButton()
        @btn2 = new CC.views.draw.MouseButton()
        @btn3 = new CC.views.draw.MouseButton()

        $(document.body).attr("oncontextmenu","return false")
        $(document).mousedown( (event)=> @mouseDown({x:event.clientX,y:event.clientY},event.which) )

        $(document).mousemove( (event)=> @mouseDragged({x:event.clientX,y:event.clientY},event.which) )

        $(document).mouseup( (event)=>  @mouseUp({x:event.clientX,y:event.clientY},event.which) )

    mouseDown:(point,button)->

        if button == 1                          #click sinistro
            @btn1.down = true
            @btn1.click.start = point
            @btn1.click.currentPos = point

        if button == 2                          #click centrale
            @btn2.down = true
            @btn2.click.start = point
            @btn2.click.currentPos = point

        if button == 3                          #click centrale
            @btn3.down = true
            @btn3.click.start = point
            @btn3.click.currentPos = point

    mouseDragged:(point,button)->
        if button ==1 && @btn1.down
            @btn1.click.currentPos = point
            @btn1.click.delta = {
                w:@btn1.click.oldDelta.w + point.x - @btn1.click.start.x
                h:@btn1.click.oldDelta.h + point.y - @btn1.click.start.y
            }

        if button ==2 && @btn2.down
            @btn2.click.currentPos = point
            @btn2.click.delta = {
                w:@btn2.click.oldDelta.w + point.x - @btn2.click.start.x
                h:@btn2.click.oldDelta.h + point.y - @btn2.click.start.y
            }

        if button ==3 && @btn3.down
            @btn3.click.currentPos = point
            @btn3.click.delta = {
                w:@btn3.click.oldDelta.w + point.x - @btn3.click.start.x
                h:@btn3.click.oldDelta.h + point.y - @btn3.click.start.y
            }

    mouseUp:(point,button)->
        if button == 1 && @btn1.down
            @btn1.down =false
            @btn1.click.oldDelta = @btn1.click.delta

        if button == 2 && @btn2.down
            @btn2.down =false
            @btn3.click.oldDelta = @btn3.click.delta

        if button == 3 && @btn3.down
            @btn3.down =false
            @btn3.click.oldDelta = @btn3.click.delta

    rotationX:=>
        @btn3.click.delta.h * @rotationScale
    rotationY:=>
        @btn3.click.delta.w * @rotationScale