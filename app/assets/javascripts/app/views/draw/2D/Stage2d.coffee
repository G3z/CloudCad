S.define(
    "views/draw/2D/Stage2d"
    ["views/Abstract", "views/draw/2D/tools/PathTool" , "views/draw/2D/tools/SelectTool" "views/Mouse" ]
    (Abstract, PathTool, SelectTool, Mouse)->

        class Stage2d extends Abstract
            @activePath
            @mouse
            constructor:()->
                #paper.install(window)
                $(document.body).append($("<canvas></canvas>").attr("id","canvas2d").attr("resize","true"))
                paper.setup("canvas2d")

                @mouse = new Mouse()
                
                @clickTolerance = 15
                @snapTolerance = 8

                #Gestione dei tools
                @pathTool = new PathTool(this)
                @selectTool = new SelectTool(this)
                @activeTool = @selectTool


                #Gestione degli eventi
                $(document)
                    .bind 'mouse:btn1_down', =>
                        @activeTool.mouseDown(@mouse.currentPos)
                    .bind 'mouse:btn1_drag', =>
                        @activeTool.mouseDragged(@mouse.currentPos)
                    .bind 'mouse:btn1_up', =>
                        @activeTool.mouseUp(@mouse.currentPos)

                
