S.define(
    "views/draw/2D/primitives/Point2D"
    ["views/draw/2D/primitives/AbstractPrimitive", "views/draw/2D/primitives/Path"]
    (AbstractPrimitive, Path)->
        
        class Point2D extends AbstractPrimitives
            @x
            @y
            @name
            @father
            @idx

            constructor:(@x,@y,@name,@father)->
                super()

            moveTo:(@x,@y)=>
                if @father?
                    if @father instanceof Path
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
                else if cord == "xy" || cord == "yx" || cord == "all" || cord == "both"
                    if @x <= point.x + tollerance && @x >= point.x - tollerance && @y <= point.y + tollerance && @y >= point.y - tollerance
                        return true
                return false

            remove:->
                if @father? && @father instanceof Path
                    @father.removePoint(this)

            angleWith:(point)=>
