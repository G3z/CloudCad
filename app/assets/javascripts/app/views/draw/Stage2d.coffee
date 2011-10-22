class CC.views.draw.Stage2d extends CC.views.Abstract
    @path
    @mouse
    constructor:()->
        @mouse = new CC.views.draw.Mouse()
        paper.install(window)
        $(document.body).append($("<canvas></canvas>").attr("id","canvas2d").attr("resize","true"))
        paper.setup("canvas2d")
        
        @clickTolerance = 30


        @path = new paper.Path()
        @path.strokeColor = 'black'
        @path.fillColor = '#eeeeee'
        @path.closed = true
        @path.selected = true
        @path.strokeWidth = 2
        #@path.strokeCap = 'round';

        #Gestione degli eventi
        Spine.bind 'mouse:btn1_down', =>
            @mouseDown()
        Spine.bind 'mouse:btn1_drag', =>
            if @selected==null
                @pointMove("last",@mouse.currentPos)
            else 
                @pointMove(@selected,@mouse.currentPos)
        Spine.bind 'mouse:btn1_up', =>
            if @selected==null
                @pointMove("last",@mouse.currentPos)
            else 
                @pointMove(@selected,@mouse.currentPos)
                @selected=null
                        
    update:=>
        paper.view.draw()

    mouseDown:=>
        mousePoint = new Point(@mouse.currentPos.x, @mouse.currentPos.y)
        if @path.segments.length != 0
            for i in [0...@path.segments.length]
                if @path.segments[i].point.getDistance(mousePoint,false)<@clickTolerance
                    console.log("trovato")
                    @selected = i
                
            if @selected == null
                @selected = null
                @createPath()
        else
            @createPath()
            @selected = null            

    createPath:=>
        if (@path.segments.length == 0)
            @path.add(@mouse.currentPos)
        @path.add(@mouse.currentPos)
        @update()
    
    pointMove:(point,destPoint)=>
        if point=="last"
            @path.lastSegment.point = destPoint
        else
            @path.segments[@selected].point.x = destPoint.x
            @path.segments[@selected].point.y = destPoint.y
            console.log("trovato")

        @update()
    onFrame:(event)->
        @update()
        