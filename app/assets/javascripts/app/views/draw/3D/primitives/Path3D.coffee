### Path3D Class ###
# Path3D Class combines Three.js path and shape classes providing an object that is editable under mouse interaction and that easily convertible into a solid shape
define(
    "views/draw/3D/primitives/Path3D"
    [
        "views/draw/3D/primitives/Primitive"
        "views/draw/3D/primitives/Point3D"
        "views/draw/3D/primitives/Segment"
        "views/draw/3D/primitives/Solid3D"
    ],
    (Primitive,Point3D,Segment,Solid3D)->
        class CC.views.draw.primitives.Path3D extends Primitive
            @points
            @segments
            @plane
            @lastPoint
            @selectedPoint
            @selectedSegment
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

                defaults = {
                    points : []
                    name : undefined
                    color : 0x8866ff
                    selectedColor : 0x0000bb
                    layer:"scene"
                }

                unless attr?
                    @points = defaults.points
                    @name = defaults.name
                    @color = defaults.color
                    @selectedColor = defaults.selectedColor
                    layer = defaults.layer
                else
                    if attr.points? then @points = attr.points else @points = defaults.points
                    if attr.name? then @name = attr.name else @name = defaults.name
                    if attr.color? then @color = attr.color else @color = defaults.color
                    if attr.selectedColor? then @selectedColor = attr.selectedColor else @selectedColor = defaults.selectedColor
                
                @createGeometry()
                
            createGeometry:=>
                if @line?
                    @remove(@line)
                color = unless @selected then @color else @selectedColor
                @line = new THREE.Line(
                                            new THREE.CurvePath.prototype.createGeometry(@points),
                                            new THREE.LineBasicMaterial( {
                                                color: color
                                                linewidth: 2
                                            })
                                        )
                @line.father = this
                @add(@line)
                
                particles = new THREE.Geometry()
                pMaterial = new THREE.ParticleBasicMaterial({
                    color: @color,
                    size: 10
                })
                for vertice, i in @points
                    if i < @points.length
                        particle = new THREE.Vertex(vertice)
                        particles.vertices.push(particle)
                        particle.father = this
                        particle.idx = i
                        position = new THREE.Vector3(vertice.x,vertice.y,@position.z)

                        size = 8
                        cube = new THREE.Mesh(new THREE.CubeGeometry(size,size,size),new THREE.MeshBasicMaterial({
                                color: @color
                                opacity: 0.25
                                transparent: true
                                wireframe: true
                            }))
                        cube.placeholder = true
                        cube.visible = false
                        cube.vertexIndex = i
                        cube.position.x = vertice.x
                        cube.position.y = vertice.y
                        cube.father = this
                        @line.add(cube)
                    
                @particleSystem = new THREE.ParticleSystem(
                    particles,
                    pMaterial
                )
                @particleSystem.dynamic = true
                @particleSystem.father = this
                @line.add(@particleSystem)
            
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
                @lastPoint = @point("last")
                @line.geometry.__dirtyVertices = true
                @line.geometry.__dirtyNormals = true
                @particleSystem.geometry.__dirtyVertices = true
            
            #### *start(`point`)* method takes one argument
            #* the starting *point* from wich the Path should start
            start:(point)=>
                point = @validatePoint(point)
                if point
                    point.idx = @points.length
                    point.father = this
                    @points.push(point)

            #### *add(`point`)* method takes one argument
            #* the *point* to be added to the Path
            #add:(point)=>
            #    point = @validatePoint(point)
            #    if point
            #        point.idx = @points.length
            #        point.father = this
            #        @points.push(point)
            #        if @points.length>0
            #        else

            insert:(idx,point)=>
                
                #debugger
                split = idx
                idx++

                points_before = @points[0..split]
                points_before.push(point)
                points_after = @points[idx..@points.length-1]
                @points = points_before.concat(points_after)
                @points[0] = @points[@points.length-1]
                @createGeometry()
                @update()
                

            #remove:(el)=>
            #    if el instanceof Point3D
            #        @removePoint(el)
            #    else if el instanceof Segment
            #        @removeSegment(el)

            removePoint:(point)=>
                ###
                @points.remove(point) if point in @points
                @paperPath.removeSegment(point.idx)
                @rearrangePoints()
                ###

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
                @update()

            moveSegment:(el,newPos)=>

            point:(selector)=>
                ###
                unless selector?
                    return null
                else if selector == "last"
                    return @points[@points.length-1]
                else if selector == "first"
                    return @points[0]
                else if selector == "selected"
                    return @points[@selectedPoint]
                else if typeof(selector) == "number" && selector < @points.length && selector > -1
                    return @points[parseInt(selector)]
                ###
            
            pointNear:(point,tollerance)=>
                ###
                for i in [0...@segments.length]
                    if @paperPath.segments[i].point.isClose(point,tollerance)
                        @selectedPoint = i
                        return @selectedPoint
                return null
                ###
            
            segmentNear:(point,tollerance)=>
                ###
                #debugger
                nearPoint = @paperPath.getNearestPoint(new paper.Point(point.x,point.y))
                circle = new paper.Path.Circle(nearPoint, 3);
                @update()
                if nearPoint.isClose(point,tollerance)
                    for segment in @paperPath.segments
                        start = segment.point
                        if segment.index < @paperPath.segments.length
                            end = segment.next.point
                        else
                            end = @paperPath.segments[0].point
                        crossproduct = (nearPoint.y - start.y) * (end.x - start.x) - (nearPoint.x - start.x) * (end.y - start.y)
                        dotproduct = (nearPoint.x - start.x) * (end.x - start.x) + (nearPoint.y - start.y)*(end.y - start.y)
                        squaredlengthba = (end.x - start.x)*(end.x - start.x) + (end.y - start.y)*(end.y - start.y)

                        if Math.abs(crossproduct) <= 0.000001 && dotproduct <= squaredlengthba && dotproduct >= 0
                            return segment.index

                else
                    false
                ###

            #### *extrude(`point`)* method takes one argument
            #* the *lenght* of the extrusion  
            # This method returns a new mesh containig the extruded shape  
            # Path is turned invisible when creating the 3D shape
            extrude:(value)=>
                
                @extrusion = new Solid3D({
                    generator: this
                    extrusionValue : value
                })
                if value < 0
                    @extrusion.mesh.flipSided = true
                @extrusion.generator = this
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
                else if point instanceof Point3D
                    return point
                else
                    return false

            rearrangePoints:=>
                i=0
                for point in @points    
                    point.idx = i 
                    i++
)
            