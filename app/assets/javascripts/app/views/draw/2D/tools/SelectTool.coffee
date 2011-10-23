class CC.views.draw.SelectTool extends CC.views.draw.Tool2D
    @selectedIdx
    constructor:(stage2d)->
        super(stage2d)
        @selectedIdx=null
        @path = @stage2d.path

    mouseDown:(eventpoint)=>
        

    mouseDragged:(eventPoint)=>


    mouseUp:(eventPoint)=>
        mousePoint = new CC.views.draw.primitives.Point(@stage2d.mouse.currentPos.x, @stage2d.mouse.currentPos.y,"")

