### Path3D Class ###
# Path3D Class combines Three.js path and shape classes providing an object that is editable under mouse interaction and that easily convertible into a solid shape
S.export(
    "views/draw/3D/primitives/Path3D"
    [
        "views/draw/3D/primitives/Primitive"
        "views/draw/3D/primitives/Point3D"
        "views/draw/3D/primitives/Segment"
        "views/draw/3D/primitives/Solid3D"
    ],
    (Primitive,Point3D,Segment,Solid3D)->
        class Path3D extends Primitive
            @points
            @segments
            @plane
            @lastPoint
            @closed
            #### *constructor(`attr`)* method takes one argument
            #* the *attr* object that cointains various options  
            #Currently these options are supported:  
            #   * *color*: (the color of the path and of the extruded mesh)
            #   * *points*: (an array of points representig the points of the path)
            #   * *name*: (a name for the object, useful for yet to be implemented object referencing)
            #   * *start*: a single point where the path is starting
            #
            # If one of the above options isn't specified or attr isn't given the appropriate default is set.  
            constructor:(attr)->
                super()
                @closed = false
                defaults = {
                    points : []
                    name : undefined
                    color : 0x8866ff
                    selectedColor : 0x0000bb
                }

                unless attr?
                    @points = defaults.points
                    @name = defaults.name
                    @color = defaults.color
                    @selectedColor = defaults.selectedColor
                else
                    if attr.points? then @points = attr.points else @points = defaults.points
                    if attr.name? then @name = attr.name else @name = defaults.name
                    if attr.color? then @color = attr.color else @color = defaults.color
                    if attr.selectedColor? then @selectedColor = attr.selectedColor else @selectedColor = defaults.selectedColor
                    if attr.layer? then @layer = attr.layer

                @createGeometry()
                @addToLayer()
                
            createGeometry:=>
                console.log @class,"create Geometry"
                if @line?
                    @remove(@line)
                if @points.length > 0
                    color = unless @selected then @color else @selectedColor
                    @line = new THREE.Line(
                        new THREE.CurvePath.prototype.createGeometry(@points),
                        new THREE.LineBasicMaterial
                            color: color
                            linewidth: 2
                            blending: THREE.AdditiveAlphaBlending
                    )
                    @line.translateZ(1)
                    @line.father = this
                    @add(@line)
                    
                    particles = new THREE.Geometry()
                    pMaterial = new THREE.ParticleBasicMaterial({
                        color: @color,
                        size: 10
                    })
                    for vertice, i in @points
                        point = @validatePoint(vertice)
                        if point
                            point.idx = i
                            point.father = this
                            @points[i] = point
                        particle = new THREE.Vertex(vertice)
                        particles.vertices.push(particle)
                        particle.father = this
                        particle.idx = i
                        position = new THREE.Vector3(vertice.x,vertice.y,@position.z)
                    
                    @particleSystem = new THREE.ParticleSystem(
                        particles,
                        pMaterial
                    )
                    @particleSystem.dynamic = true
                    @particleSystem.father = this
                    if @points[0] == @points[@points.length-1]
                        @closed = true
                    @line.add(@particleSystem)
                else
                    debugger
            
            #### *toggleSelection(`hexColor`)* method takes one argument
            #* the *hexColor* number that represent the color for the selection  
            #
            # If object is not selected then selection color is applied otherwise the original color is applied
            toggleSelection:()=>
                if @selected
                    @selected = false
                    @line.material.color.setHex(@color)
                else
                    @selected = true
                    @line.material.color.setHex(@selectedColor)

            #### *update()* method takes no argument
            #Update forces updates to the internals
            update:=>
                @rearrangePoints()
                @lastPoint = @point("last")
                @line.geometry.__dirtyVertices = true
                @line.geometry.__dirtyNormals = true
                @particleSystem.geometry.__dirtyVertices = true
            
            #### *start(`point`)* method takes one argument
            #* the starting *point* from wich the Path should start
            start:(point)=>
                point = @validatePoint(point)
                if point?
                    point.idx = @points.length
                    point.father = this
                    @points.push(point)

            #### *lineTo(`point`)* method takes one argument
            #* the *point* to be added to the Path
            lineTo:(point)=>
                validPoint = @validatePoint(point)
                if validPoint?
                    validPoint.idx = @points.length
                    @points.push(validPoint)
                    @createGeometry()
                    @update()

            insert:(idx,point)=>
                validPoint = @validatePoint(point)
                if validPoint?
                    split = idx
                    idx++
                    
                    points_before = @points[0..split]
                    points_before.push(validPoint)
                    points_after = @points[idx...@points.length]

                    @points = points_before.concat(points_after)
                    @points[0] = @points[@points.length-1]

                    @createGeometry()
                    @update()
                

            remove:(el)=>
                if el instanceof Point3D
                    @removePoint(el)
                else if el instanceof Segment
                    @removeSegment(el)

            removePoint:(point)=>
                points_before = @points[0...point.idx]
                points_after = @points[point.idx+1...@points.length]
                
                @points = points_before.concat(points_after)
                @createGeometry()
                @update()

            move:(el,newPos)=>
                if el instanceof Point3D
                    @movePoint(el,newPos)
                else if el instanceof Segment
                    @moveSegment(el,newPos)

            #### *movePoint(`index`,`newPoint`)* method takes two argument
            #* the *index* of the point that has to be moved
            #* the *newPoint* representing the new position of the element  
            #this method simply update the position of the vertex at the given index and triggers the update method once done
            movePoint:(index,newPoint)=>
                if index == 0
                    last = @points.length-1
                    @points[0] = newPoint
                    @points[last] = newPoint

                    @line.geometry.vertices[0].position = newPoint
                    @line.geometry.vertices[last].position = newPoint
                    
                    @particleSystem.geometry.vertices[0].position = newPoint
                    @particleSystem.geometry.vertices[last].position = newPoint
                else
                    @points[index] = newPoint
                    @line.geometry.vertices[index].position = newPoint
                    @particleSystem.geometry.vertices[index].position = newPoint
                #@createGeometry()
                @update()

            moveSegment:(el,newPos)=>

            point:(selector)=>
                intSel = parseInt(selector,10)
                unless selector?
                    return null
                else if selector == "last"
                    return @points[@points.length-1]
                else if selector == "first"
                    return @points[0]
                else if _.isNumber(intSel) && intSel < @points.length && intSel > -1
                    return @points[intSel]
                
            
            pointNear:(point,tolerance)=>
                for myPoint,i in @points
                    if myPoint.isNear("all",point,tolerance)
                        return myPoint
                return null
            
            segmentNear:(point,tolerance)=>
                for myPoint,i in @points
                    unless i == @points.length-1 
                        next = @points[i+1]
                                          
                        lineMag = myPoint.distanceTo(next)
                        U = (((point.x - myPoint.x) * (next.x - myPoint.x)) + ((point.y - myPoint.y) * (next.y - myPoint.y)) + ((point.z - myPoint.z) * (next.z - myPoint.z))) / (lineMag * lineMag)
                          
                        unless (U < 0.0 || U > 1.0)
                            intersection = new THREE.Vector3()

                            intersection.x = myPoint.x + U * (next.x - myPoint.x)
                            intersection.y = myPoint.y + U * (next.y - myPoint.y)
                            intersection.z = myPoint.z + U * (next.z - myPoint.z)
                              
                            if point.distanceTo(intersection) <= tolerance
                                return [[myPoint,next],intersection]
                return null

            #### *extrude(`point`)* method takes one argument
            #* the *lenght* of the extrusion  
            # This method returns a new mesh containig the extruded shape  
            # Path is turned invisible when creating the 3D shape
            extrude:(value)=>
                if @points.length>2
                    if value? then value = value
                    @line.position = new THREE.Vector3()
                    @extrusion = new Solid3D({
                        generator: this
                        extrusionValue : value
                    })
                    #if value < 0
                        #@extrusion.mesh.flipSided = true
                    @extrusion.position = @position
                    @extrusion.rotation = @rotation

                    @parent?.add(@extrusion)
                    @parent?.remove(this)
                    if window.stage3d.selectedObject?.id == @id
                        window.stage3d.selectedObject = @extrusion
                        @extrusion.toggleSelection()

            #### *validatePoint(`point`)* method takes one argument
            #* the *point* variable that needs to be checked  
            # This method checks if the argument is a valid point and attemps to create one if it can othwise `false` is returned
            validatePoint:(point)=>
                if point instanceof Array
                    if point.length == 2
                        if @name?
                            return point = new Point3D(point[0],point[1],name + points.length,this) 
                        else
                            return point = new Point3D(point[0],point[1],null,this)
                else if point.class? == "Point3D"
                    return point
                else if point.x? and point.y? and point.z?
                    return new Point3D(point.x,point.y,point.z)
                else
                    return null

            rearrangePoints:=>
                for point,i in @points    
                    point.idx = i
)
            
