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
               @father.paperPath.segments[@idx].selected = true
               @father.update()

    coords:=>
        [@x,@y]

    isNear:(cord,point,tollerance)=>
        if cord == "x"
            if @x <= point.x + tollerance && @x >= point.x - tollerance
                return true
        else if cord == "y"
            if @y <= point.y + tollerance && @y >= point.y - tollerance
                return true
        else if cord == "xy"
            if @x <= point.x + tollerance && @x >= point.x - tollerance && @y <= point.y + tollerance && @y >= point.y - tollerance
                return true
        return false

    angleWith:(point)=>
