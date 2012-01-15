### Solid3D Class ###
# Solid3D is the main class for all solids, currently only extrusion solid are supported generated via Path3D
S.export(
    "views/draw/3D/primitives/Solid3D"
    [
        "views/draw/3D/primitives/Primitive"
        "views/draw/3D/primitives/Point3D"
        "views/draw/3D/primitives/Segment"
        "views/draw/3D/primitives/Path3D"
    ],
    (Primitive,Point3D,Segment,Path3D)->
        class Solid3D extends Primitive
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
            #   * *generator*: (the Path3D that defined the shape)
            #   * *extrusionValue*: (the value of the extrusion)
            #
            # If one of the above options isn't specified or attr isn't given the appropriate default is set.  
            # After the initial checks `@createGeometry` is fired
            constructor:(attr)->
                super()

                defaults = {
                    generator : undefined
                    extrusionValue : undefined
                    steps : 1
                    color : 0x8866ff
                }

                unless attr?
                    @generator = defaults.generator
                    @extrusionValue = defaults.extrusionValue
                    @steps = defaults.steps
                    @color = defaults.color
                else
                    if attr.generator? then @generator = attr.generator else @generator = defaults.generator
                    if attr.extrusionValue? then @extrusionValue = attr.extrusionValue else @extrusionValue = defaults.extrusionValue
                    if attr.steps? then @steps = attr.steps else @steps = defaults.steps
                    if attr.color? then @color = attr.color else @color = defaults.color
                    if attr.layer? then @layer = attr.layer

                @createGeometry()
                @addToLayer()

            #### *createGeometry()* method takes no argument
            #
            # In this function the whole geometry is created points are drawn and colliders are added to them
            createGeometry:=>
                console.log @class,"create Geometry"
                if @mesh?
                    @remove(@mesh)
                # Currently only linear extruded meshes are suported
                if @generator? and @generator.class = "Path3D"
                    shape = new THREE.Shape(@generator.points)
                    material = new THREE.MeshLambertMaterial
                        color: @generator.color
                        ambient: 0x111111
                        blending: THREE.AdditiveAlphaBlending
                        shading: 1
                    #mesh is created as an extrusion of it's generator
                    @mesh = new THREE.Mesh(
                        shape.extrude
                            amount:@extrusionValue
                            bevelEnabled:false
                            steps:@steps
                            material: material
                            extrudeMaterial: material
                        material
                    )
                    for face,i in @mesh.geometry.faces
                        unless @mesh.geometry.vertices[face.a].faces?
                            @mesh.geometry.vertices[face.a].faces = [i]
                        else
                            if @mesh.geometry.vertices[face.a].faces.indexOf(i) == -1
                                @mesh.geometry.vertices[face.a].faces.push(i)
                        
                        unless @mesh.geometry.vertices[face.b].faces?
                            @mesh.geometry.vertices[face.b].faces = [i]
                        else
                            if @mesh.geometry.vertices[face.b].faces.indexOf(i) == -1
                                @mesh.geometry.vertices[face.b].faces.push(i)
                        
                        unless @mesh.geometry.vertices[face.c].faces?
                            @mesh.geometry.vertices[face.c].faces = [i]
                        else
                            if @mesh.geometry.vertices[face.c].faces.indexOf(i) == -1
                                @mesh.geometry.vertices[face.c].faces.push(i)
                        if face.d?
                            unless @mesh.geometry.vertices[face.d].faces?
                                @mesh.geometry.vertices[face.d].faces = [i]
                            else
                                if @mesh.geometry.vertices[face.d].faces.indexOf(i) == -1
                                    @mesh.geometry.vertices[face.d].faces.push(i)
                    @mesh.geometry.dynamic = true
                    @mesh.father = this
                    @add(@mesh)

                    for vertice,i in @mesh.geometry.vertices
                        #for each vertice a cube shape collider is added
                        size = 8
                        cube = new THREE.Mesh(new THREE.CubeGeometry(size,size,size),new THREE.MeshBasicMaterial({
                                color: @color*1.1
                                opacity: 0.25
                                transparent: true
                                wireframe: true
                            }))
                        cube.placeholder = true
                        cube.visible = false
                        cube.vertexIndex = i
                        cube.position = vertice.position
                        cube.father = this
                        @mesh.add(cube)
            
            #### *toggleSelection(`hexColor`)* method takes one argument
            #* the *hexColor* number that represent the color for the selection  
            #
            # If object is not selected then selection color is applied otherwise the original color is applied
            toggleSelection:(hexColor)=>
                color = if hexColor? then hexColor else 0x0000bb
                if @selected
                    @selected = false
                    @mesh.material.color.setHex(@color)
                else
                    @selected = true
                    @mesh.material.color.setHex(color)

            #### *update()* method takes no argument
            #Update forces updates to the internals
            update:=>
                @mesh.geometry.computeBoundingBox()
                @mesh.geometry.computeCentroids()
                @mesh.geometry.computeFaceNormals()
                @mesh.geometry.__dirtyVertices = true
                @mesh.geometry.__dirtyNormals = true
                @mesh.geometry.computeCentroids()
            
            booleanOps:(op,target)=>
                if target.parent?
                    if target.isChildOf(this)
                        @remove(@mesh)
                        target.promoteTo(this)
                        target.parent.remove(target)
                        
                        target = THREE.CSG.toCSG(target.mesh,target.position,target.rotation)
                        self = THREE.CSG.toCSG(@mesh)

                        if op == "plus"
                            geometry = THREE.CSG.fromCSG( self.union(target) )
                        else if op == "minus"
                            geometry = THREE.CSG.fromCSG( self.subtract(target) )
                        else if op == "intersect"
                            geometry = THREE.CSG.fromCSG( self.intersect(target) )
                        
                        @mesh = new THREE.Mesh( geometry, @mesh.material )
                        @mesh.father = this
                        @add(@mesh)


            plus:(object)=>
                @booleanOps("plus",object)
            
            minus:(object)=>
                @booleanOps("minus",object)
            
            intersect:(object)=>
                @booleanOps("intersect",object)
            
            facesWithNormal:(normal,output)=>
                if output == "faces" or output == "centroids"
                    result = []
                    for face in @mesh.geometry.faces
                        if face.normal.x == normal.x and face.normal.y == normal.y and face.normal.z == normal.z
                            if output == "faces"
                                result.push face
                            else if output == "centroids"
                                result.push face.centroid
                else
                    result = {}
                    for face,i in @mesh.geometry.faces
                        if face.normal.x == normal.x and face.normal.y == normal.y and face.normal.z == normal.z
                            result[face.a] = true
                            result[face.b] = true
                            result[face.c] = true
                            if face.d?
                                result[face.d] = true                            
                    vertexIndices = Object.keys(result)
                    if output == "vertex"
                        result = [] 
                        for idx in vertexIndices
                            result.push @mesh.geometry.vertices[idx]
                    else if output == "vertexIndices"
                        result = vertexIndices
                return result

            vertexIndexForFacesWithNormal:(normal)=>
                vertices = {}
                faces = @facesWithNormal(normal,"faces")
                for face in faces
                    vertices[parseInt(face.a)] = true
                    vertices[parseInt(face.b)] = true
                    vertices[parseInt(face.c)] = true
                    if face.d?
                        vertices[parseInt(face.d)] = true
                return Object.keys(vertices)
            
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
            
