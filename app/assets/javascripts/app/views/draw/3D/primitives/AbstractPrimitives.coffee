class CC.views.draw.primitives.AbstractPrimitives
    @id
    @name
    constructor:(@id = Math.guid())->
    
    validatePoint:(point)=>
        if point instanceof Array
            if point.length == 2
                if @name?
                    return point = new CC.views.draw.primitives.Point(point[0],point[1],name + points.length,this) 
                else
                    return point = new CC.views.draw.primitives.Point(point[0],point[1],null,this)
        else if point instanceof CC.views.draw.primitives.Point
            return point
        else
            return false