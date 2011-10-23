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
            if typeof(@father) == CC.views.draw.primitives.Path
               @father.paperPath.segments[0].point.x = @x
               @father.paperPath.segments[0].point.y = @y
               @father.update()
        console.log @father,@x,@y
    coords:=>
        [@x,@y]
