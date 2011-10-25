class CC.views.draw.primitives.Line extends CC.views.draw.primitives.AbstractPrimitives
    constructor:(@start,@end,@name)->
        super()

        if @start instanceof Array
            if @start.length == 2
                if @name?
                    @start = new CC.views.draw.primitives.Point(@start[0],@start[1],name + "0",this) 
                else
                    @start = new CC.views.draw.primitives.Point(@start[0],@start[1],null,this) 

        if @end instanceof Array
            if @end.length == 2
                if @name?
                    @end = new CC.views.draw.primitives.Point(@end[0],@end[1],name + "1",this) 
                else
                    @end = new CC.views.draw.primitives.Point(@end[0],@end[1],null,this) 

        @paperPath = new paper.Path.Line(@start,@end)
        @paperPath.strokeColor = 'blue'
        @paperPath.strokeWidth = 2
        @update()
    
    isPointInLine:(point)=>
        crossproduct = (point.y - @start.y) * (@end.x - @start.x) - (point.x - @start.x) * (@end.y - @start.y)
        dotproduct = (point.x - @start.x) * (@end.x - @start.x) + (point.y - @start.y)*(@end.y - @start.y)
        squaredlengthba = (@end.x - @start.x)*(@end.x - @start.x) + (@end.y - @start.y)*(@end.y - @start.y)
        if Math.abs(crossproduct) <= 0.000001 && dotproduct <= squaredlengthba && dotproduct >= 0
            return true
        false

    update:->
        paper.view.draw()