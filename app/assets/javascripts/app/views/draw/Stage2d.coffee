class CC.views.draw.Stage2d extends CC.views.Abstract
    @path
    @mouse
    constructor:()->
        @mouse = new CC.views.draw.Mouse()
        paper.install(window)
        $(document.body).append($("<canvas></canvas>").attr("id","canvas2d").attr("resize","true"))
        paper.setup("canvas2d")

        @path = new paper.Path()
        @path.strokeColor = 'black'
        @path.closed = true     

        #Gestione degli eventi
        Spine.bind 'mouse:btn1_down', =>
            @createPath()
        Spine.bind 'mouse:btn1_drag', =>
            @pointMove("last",@mouse.currentPos)
                        
    update:=>
        paper.view.draw()
    createPath:=>
        if (@path.segments.length == 0)
            @path.add(@mouse.currentPos)
        @path.add(@mouse.currentPos)
        @update()
    
    pointMove:(point,destPoint)=>
        if point="last"
            @path.lastSegment.point = destPoint;
        @update()
        
    
