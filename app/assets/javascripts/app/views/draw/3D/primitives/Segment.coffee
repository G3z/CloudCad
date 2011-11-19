define(
    "views/draw/3D/primitives/Segment"
    ["views/draw/3D/primitives/Primitive","views/draw/3D/primitives/Path3D"],
    (Primitive,Path3D)->
        class CC.views.draw.primitives.Segment extends Primitive
            @x
            @y
            @z
            @name
            @father
            @idx

            constructor:(@x,@y,@z,@name,@father)->
                super()

            moveTo:(@x,@y,@z)=>
                if @father?
                    if @father instanceof Path3D
                       @father.ThreePath.geometry.vertices[@idx].position.x = @x
                       @father.ThreePath.geometry.vertices[@idx].position.y = @y
                       #@father.ThreePath.geometry.vertices[@idx].selected = true
                       @father.update()

            coords:=>
                [@x,@y,@z]

            isNear:(cord,point,tollerance)=>
                if cord == "x"
                    if @x <= point.x + tollerance && @x >= point.x - tollerance
                        return true
                else if cord == "y"
                    if @y <= point.y + tollerance && @y >= point.y - tollerance
                        return true
                else if cord == "z"
                    if @z <= point.z + tollerance && @z >= point.z - tollerance
                        return true
                else if cord == "xy" || cord == "yx"
                    if @x <= point.x + tollerance && @x >= point.x - tollerance && @y <= point.y + tollerance && @y >= point.y - tollerance
                        return true
                else if cord == "xz" || cord == "zx"
                    if @x <= point.x + tollerance && @x >= point.x - tollerance && @z <= point.z + tollerance && @z >= point.z - tollerance
                        return true
                else if cord == "yz" || cord == "zy"
                    if @y <= point.y + tollerance && @y >= point.y - tollerance && @z <= point.z + tollerance && @z >= point.z - tollerance
                        return true
                else if cord == "all"
                    if @x <= point.x + tollerance && @x >= point.x - tollerance && @y <= point.y + tollerance && @y >= point.y - tollerance && @z <= point.z + tollerance && @z >= point.z - tollerance
                        return true
                return false

            remove:->
                if @father? && @father instanceof Path3D
                    @father.removePoint(this)

            angleWith:(point)=>
)