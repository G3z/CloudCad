define(
    "views/draw/3D/primitives/Point3D"
    ["views/draw/3D/primitives/Primitive","views/draw/3D/primitives/Path3D"],
    (Primitive,Path3D)->
        class CC.views.draw.primitives.Point3D extends THREE.Vector3
            @x
            @y
            @z
            @name
            @father
            @idx

            constructor:(@x,@y,@z,@name,@father)->
                super(@x,@y,@z)
                if @constructor.toString?
                    arr = @constructor.toString().match(/function\s*(\w+)/)
                    if arr? and  arr.length == 2
                        @class = arr[1]
                @id = Math.guid()

            moveTo:(@x,@y,@z)=>
                if @father?
                    if @father.class = "Path3D"
                       @father.points[@idx].position.x = @x
                       @father.points[@idx].position.y = @y
                       @father.points[@idx].position.z = @z
                       @father.points[@idx].selected = true
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
            
            toString:=>
                "x:#{@x}\ny:#{@y}\nz:#{@z}"
                
            remove:->
                if @father? && @father instanceof Path3D
                    @father.removePoint(this)

            angleWith:(point)=>
)