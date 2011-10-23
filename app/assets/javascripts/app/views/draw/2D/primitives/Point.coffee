class CC.views.draw.primitives.Point extends CC.views.draw.primitives.AbstractPrimitives
    @x
    @y
    @name
    @father
    @idx
    constructor:(@x,@y,@name,@father)->
        super()
    moveTo:(@x,@y)=>
        if @father?
            if @father instanceof CC.views.draw.primitives.Path
               @father.paperPath.segments[@idx].point.x = @x
               @father.paperPath.segments[@idx].point.y = @y
               @father.update()

    coords:=>
        [@x,@y]