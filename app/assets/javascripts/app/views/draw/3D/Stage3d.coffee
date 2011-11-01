class CC.views.draw.Stage3d extends CC.views.Abstract
    ###
    This class represent the Stage area where all the elements are represented
    ###
    @rotationScale
    @camera
    @scene
    @renderer
    @geometry
    @material
    @mesh
    @light
    @ambientLight
    @origin
    @selectedMesh

    constructor:(@glOrNot)->
        super()
        @rotationScale = 0.003
        @zoomScale = 4
        @zoom = 1
        @lastvert =0

        # Setup camera
        #camera = new CC.views.draw.Camera(35, (window.innerWidth-50) / (window.innerHeight-50), 1, 15000)
        @camera = new CC.views.draw.Camera((window.innerWidth),(window.innerHeight-50),35, 1, 15000,1, 15000).threeCamera
        @camera.position.z = 1000 * @zoom

        # Create the real Scene
        @scene = new THREE.Scene()
        @projector = new THREE.Projector()
        #
        #@mesh.dynamic = true
        #@mesh.append(new THREE.Axes())
        @world = new THREE.Object3D()
        @scene.add(@world)
        # Add a light
        @light = new THREE.DirectionalLight(0xFFFF00)
        @light.position.set( 400, 300, 400 )
        @scene.add( @light )

        # Add ambient light
        @ambientLight = new THREE.AmbientLight( 0x888888, )
        @scene.add(@ambientLight)

        # Setup a renderer
        @canvas = document.createElement( 'canvas' )
        $(@canvas).attr("id","canvas3d")
        if glOrNot == "canvas"
            @renderer =new THREE.CanvasRenderer({canvas:canvas})
        else if glOrNot == "svg"
            @renderer =new THREE.SVGRenderer({canvas:canvas})
        else
            @renderer = new THREE.WebGLRenderer({
                antialias: true
                canvas: @canvas
                clearColor: 0x111188
                clearAlpha: 0.2
                maxLights: 4
                stencil: true
                preserveDrawingBuffer: false
            })
            #@renderer.setFaceCulling("back","cw")

        # Define rendere size
        @renderer.setSize( window.innerWidth, window.innerHeight-50 )

        # Add the element to the DOM
        document.body.appendChild( @renderer.domElement )

        # Handle mouse events
        @mouse = new CC.views.draw.Mouse()
        @createGeom()

        # Event listeners
        Spine.bind 'mouse:wheel_changed', =>
            @updateCameraZoom()

        Spine.bind 'mouse:btn1_down', =>
            debug("MOUSE DOWN")
            vector = new THREE.Vector3(
                @mouse.currentPos.stage3Dx,
                @mouse.currentPos.stage3Dy,
                0.5
            )

            #vector = new THREE.Vector3( @mouse.currentPos.x, @mouse.currentPos.y, 0.5 )
            #console.log(vector.x + " " + vector.y)
            @projector.unprojectVector(vector, @camera)
            ray = new THREE.Ray(@camera.position, vector.subSelf( @camera.position ).normalize())

            c = THREE.Collisions.rayCastNearest(ray)

            if c?
                if c.mesh?

                    if @selectedMesh?
                        @selectedMesh.materials[0].color.setHex(0x53aabb)

                    c.mesh.materials[0].color.setHex(0x0000bb)
                    @selectedMesh = c.mesh

                else if c.particle?
                    c.particle.line.materials[0].color.setHex(0xbb0000)
                else
                    @selectedMesh = null
                #console.log(@mouse.currentPos.stage3Dx + " " + @mouse.currentPos.stage3Dy + " - " + @mouse.currentPos.x + " " + @mouse.currentPos.y)
                #console.log(c)
                #c[0].particle.line.materials[0].color.setHex(0xbb0000)
            else
                @selectedMesh = null

        Spine.bind 'mouse:btn1_up', =>
            if @selectedMesh?
                @selectedMesh.materials[0].color.setHex(0x53aabb)

        Spine.bind 'mouse:btn1_drag', =>
            debug(@mouse.btn1.delta.w)
            if !@selectedMesh || @mouse.btn1.delta.w * 1 != @mouse.btn1.delta.w || @mouse.btn1.delta.h * 1 != @mouse.btn1.delta.h
                return

            @selectedMesh.position.x += @mouse.btn1.delta.w #TODO: da correggere
            @selectedMesh.position.y -= @mouse.btn1.delta.h #TODO: da correggere

            #Aggiorno la gemetria della linea
            index = @selectedMesh.vertexIndex
            # Dato che entrambe le linee usano lo stesso insieme di vertici modificandolo modifico entrambe
            @linea.geometry.vertices[index].position.x = @selectedMesh.position.x
            @linea.geometry.vertices[index].position.y = @selectedMesh.position.y
            #@mesh.shape.geometry.vertices[index].position.x = @selectedMesh.position.x
            #@mesh.shape.geometry.vertices[index].position.y = @selectedMesh.position.y

            # Forzo il ridisegno della gemetry http://aerotwist.com/lab/getting-started-with-three-js/

            @linea.geometry.__dirtyVertices = true
            @linea.geometry.__dirtyNormals = true
            #@mesh.geometry.__dirtyVertices = true
            #@mesh.geometry.__dirtyNormals = true


        #Spine.bind 'mouse:btn1_down', =>
        #    @createGeom()

    animate:=>
        requestAnimFrame(@animate)
        #@world.children[0]
        #for mesh in @world.children
        #    mesh.materials[0].color.setHex(0x8866ff)

        @render()

    render:=>
        if @world?
            @world.rotation.x = @mouse.btn3.absoluteDelta.h * @rotationScale
            @world.rotation.y = @mouse.btn3.absoluteDelta.w * @rotationScale

        @renderer.render(@scene,@camera)

    updateCameraZoom:=>
        if @mouse.wheel.direction == "UP"
            multiplier = 1
        else
            multiplier = -1

        @camera.position.z += multiplier * @mouse.wheel.speed * @zoomScale

    createGeom:=>
        @vertices =[
            new THREE.Vector2(0,0)
            new THREE.Vector2(100,0)
            new THREE.Vector2(100,100)
            new THREE.Vector2(0,100)
            new THREE.Vector2(0,0)
        ]

        color = 0x8866ff
        x = 0
        y = 0
        z = 0
        rx = 0
        ry = 0
        rz = 0
        s = 1

        shape = new THREE.Shape(@vertices)
        points = shape.createPointsGeometry()

        # Linea spessa
        line = new THREE.Line(points, new THREE.LineBasicMaterial( { color: color, linewidth: 2 }))
        line.position.set(x, y, z + 25)
        line.rotation.set(rx, ry, rz)
        line.scale.set(s, s, s)
        @world.add(line)

        # Linea con handlers
        @linea = new THREE.Line(points, new THREE.LineBasicMaterial( { color: color, opacity: 0.5 }))
        @linea.position.set(x, y, z + 75)
        @linea.rotation.set(rx, ry, rz)
        @linea.scale.set(s, s, s)
        @linea.geometry.dynamic = true
        @world.add(@linea)

        # Handlers
        # // create the particle variables
        particles = new THREE.Geometry()
        pMaterial = new THREE.ParticleBasicMaterial({
            color: 0xFFFFFF,
            size: 10
        })

        for vertice, i in @vertices
            #particle = new THREE.Vertex(vertice)
            #particles.vertices.push(particle)
            #particle.line = line

            #sphereCollider = new THREE.SphereCollider(vertice, 10) # size = radius
            #sphereCollider.particle = particle # I do this so I can reference to the particle in the collision check
            #THREE.Collisions.colliders.push(sphereCollider)

            radius = 10
            segments = 16
            rings = 16
            sphere = new THREE.Mesh(
                new THREE.SphereGeometry(radius,segments,rings),
                new THREE.MeshLambertMaterial({
                    color: 0x53aabb
                })
            )
            sphere.vertexIndex = i
            sphere.position.x = vertice.x
            sphere.position.y = vertice.y

            @linea.add(sphere)

            # registro le collisioni sulle sfere
            mc = THREE.CollisionUtils.MeshColliderWBox(sphere)
            THREE.Collisions.colliders.push(mc)

        #particleSystem = new THREE.ParticleSystem(
        #    particles,
        #    pMaterial
        #)

        #line.add(particleSystem)


        #pgeo = THREE.GeometryUtils.clone( points )
        #particles = new THREE.ParticleSystem( pgeo, new THREE.ParticleBasicMaterial( { color: color, size: 3, opacity: 0.75 } ) )
        #particles.position.set( x, y, z )
        #particles.rotation.set( rx, ry, rz )
        #particles.scale.set( s, s, s )
        #line.add( particles )

        @material = new THREE.MeshLambertMaterial({
            color: 0x8866ff
            blending: 3
            shading: 1
        })

        @mesh = new THREE.Mesh(
            shape.extrude({
                amount:10,
                bevel:0,
                material: @material,
                extrudeMaterial: @material
            }),
            @material
        )
        #@path = new THREE.Path(vertices)

        @world.add( @mesh )
        #mc = THREE.CollisionUtils.MeshColliderWBox(mesh)
        #THREE.Collisions.colliders.push( mc )

