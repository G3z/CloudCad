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
        #@path.selected = true
        @path.strokeWidth = 2
        #@path.strokeCap = 'round';
        
        #Gestione dei tools
        @pathTool = new CC.views.draw.PathTool(this)
        @activeTool = @pathTool


        #Gestione degli eventi
        Spine.bind 'mouse:btn1_down', =>
            @activeTool.mouseDown(@mouse.currentPos)
        Spine.bind 'mouse:btn1_drag', =>
            @activeTool.mouseDragged(@mouse.currentPos)
        Spine.bind 'mouse:btn1_up', =>
            @activeTool.mouseUp(@mouse.currentPos)

    update:=>
        paper.view.draw()   
        