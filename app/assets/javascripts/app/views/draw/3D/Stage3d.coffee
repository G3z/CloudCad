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
        @offset = new THREE.Vector3()
        
        #@camera.toOrthographic()

        # Create the real Scene
        @scene = new THREE.Scene()
        @projector = new THREE.Projector()
        

        @world = new THREE.Object3D()
        @scene.add(@world)

        # Setup camera
        @camera = new CC.views.draw.Camera((window.innerWidth),(window.innerHeight-40),35, 1, 15000,1, 15000).threeCamera
        @camera.position.z = 1000 * @zoom
        #@camera.lookAt(@world)
        #@mouse = new CC.views.draw.Mouse(@camera)
        
        # Add a light
        @light = new THREE.SpotLight(0xFFFF00,1.0)
        @light.position.set( 400, 300, 400 )
        @scene.add( @light )

        # Add ambient light
        @ambientLight = new THREE.AmbientLight( 0x888888 )
        @scene.add(@ambientLight)
        
        @cameraPlane = new THREE.Mesh( new THREE.PlaneGeometry( 2000, 2000, 1, 1 ), new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 0.25, transparent: true, wireframe: true } ) );
        @cameraPlane.lookAt( @camera.position );
        @cameraPlane.visible = false;
        @scene.add(@cameraPlane)

        # Setup a renderer
        @canvas = document.createElement( 'canvas' )
        $(@canvas).attr("id","canvas3d")
        if glOrNot == "canvas"
            @renderer =new THREE.CanvasRenderer({canvas:@canvas})
        else if glOrNot == "svg"
            @renderer =new THREE.SVGRenderer({canvas:@canvas})
        else
            @renderer = new THREE.WebGLRenderer({
                antialias: true
                canvas: @canvas
                clearColor: 0x111188
                clearAlpha: 0.2
                maxLights: 4
                #stencil: true
                preserveDrawingBuffer: false
                sortObjects:true
            })
            #@renderer.setFaceCulling("back","cw")
        
        @mouse = new CC.views.Mouse($(@canvas))
        @keyboard = new CC.views.Keyboard()

        @cameraController = new CC.views.CameraController(this)
        @cameraController.movementSpeed = 75;
        @cameraController.lookSpeed = 0.125;
        @cameraController.lookVertical = false;
        

        # Define rendere size
        @renderer.setSize( window.innerWidth, window.innerHeight-50 )
        @renderer.shadowMapEnabled = true;
        @renderer.shadowMapSoft = true;

        @renderer.shadowCameraNear = 3;
        @renderer.shadowCameraFar = @camera.far;
        @renderer.shadowCameraFov = 50;

        @renderer.shadowMapBias = 0.0039;
        @renderer.shadowMapDarkness = 0.5;
        @renderer.shadowMapWidth = 1024;
        @renderer.shadowMapHeight = 1024;
        # Add the element to the DOM
        document.body.appendChild( @renderer.domElement )

        # Handle mouse events
        
        @createGeom()
        window.stage3d = this
        
        # Event listeners   
        Spine.bind 'mouse:btn1_down', =>
            unless window.keyboard.isAnyDown()
                vector = new THREE.Vector3(
                    @mouse.currentPos.stage3Dx
                    @mouse.currentPos.stage3Dy
                    0.5
                )

                #vector = new THREE.Vector3( @mouse.currentPos.x, @mouse.currentPos.y, 0.5 )
                #console.log(vector.x + " " + vector.y)
                @projector.unprojectVector(vector, @camera)
                ray = new THREE.Ray(@camera.position, vector.subSelf( @camera.position ).normalize())

                c = THREE.Collisions.rayCastAll(ray)

                if c[0]?
                    if c[0].mesh?

                        if @selectedMesh?
                            @selectedMesh.materials[0].color.setHex(0x53aabb)
                        #debugger
                        c[0].mesh.materials[0].color.setHex(0x0000bb)
                        @selectedMesh = c[0].mesh
                        intersects = ray.intersectObject( @cameraPlane )
                        @offset.copy( intersects[ 0 ].point ).subSelf( @cameraPlane.position )

                    else if c[0].particle?
                        if @selectedParticle?
                            @selectedParticle.materials[0].color.setHex(0x53aabb)
                        c[0].particle.father.materials[0].color.setHex(0xbb0000)
                        @selectedParticle = c[0].particle
                        #debugger
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
            unless window.keyboard.isAnyDown()
                if (!@selectedMesh and !@selectedParticle) || @mouse.btn1.delta.w * 1 != @mouse.btn1.delta.w || @mouse.btn1.delta.h * 1 != @mouse.btn1.delta.h
                    return

                if @selectedMesh?
                    @cameraPlane.position.copy( @selectedMesh.position )

                else if @selectedParticle?
                    @cameraPlane.position.copy( @selectedParticle.position )
                
                vector = new THREE.Vector3(
                    @mouse.currentPos.stage3Dx
                    @mouse.currentPos.stage3Dy
                    0.5
                )

                @projector.unprojectVector(vector, @camera)
                ray = new THREE.Ray(@camera.position, vector.subSelf( @camera.position ).normalize())

                intersects = ray.intersectObject( @cameraPlane )
                #debugger
                if intersects[0]? and intersects[0].father?
                    idx = intersects[0].idx
                    intersects[0].father.geometry.vertices[idx].position.copy(intrsects[0].position)
                if intersects[0]? 
                    newPoint = intersects[0].point.clone()
                    @selectedMesh.position.x = newPoint.x
                    @selectedMesh.position.y = newPoint.y
                    
                    #Aggiorno la gemetria della linea
                    index = @selectedMesh.vertexIndex
                    
                    # Dato che entrambe le linee usano lo stesso insieme di vertici modificandolo modifico entrambe
                    @vertices
                    @vertices[index].x = parseInt(@selectedMesh.position.x)
                    @vertices[index].y = parseInt(@selectedMesh.position.y)

                    @linea.geometry.vertices[index-1].position.x = parseInt(@selectedMesh.position.x)
                    @linea.geometry.vertices[index-1].position.y = parseInt(@selectedMesh.position.y)
                    #@linea.geometry.vertices[index-1].position.z = parseInt(@selectedMesh.position.z)

                    # Forzo il ridisegno della gemetry http://aerotwist.com/lab/getting-started-with-three-js
                    @linea.geometry.__dirtyVertices = true
                    @linea.geometry.__dirtyNormals = true

                    # Ridisegno la mesh con i nuovi punti
                    #@linea.geometry.mergeVertices()
                    #debugger
                    shape = new THREE.Shape(@vertices)
                    @world.remove(@mesh)
                    @mesh = new THREE.Mesh(
                        shape.extrude({
                            amount:10,
                            bevelEnabled:false,
                            material: @material,
                            extrudeMaterial: @material
                        }),
                        @material
                    )
                    @world.add(@mesh)
    animate:=>
        requestAnimFrame(@animate)
        @render()

    render:=>
        @cameraController.update()
        @cameraPlane.lookAt( @camera.position );
        
        @renderer.render(@scene,@camera)

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
            color: 0x8866ff,
            size: 10
        })

        for vertice, i in @vertices
            particle = new THREE.Vertex(vertice)
            particles.vertices.push(particle)
            particle.father = line
            particle.idx = i
            position = new THREE.Vector3(vertice.x,vertice.y,line.position.z)

            sphereCollider = new THREE.SphereCollider(position, 10) # size = radius
            sphereCollider.particle = particle # I do this so I can reference to the particle in the collision check
            THREE.Collisions.colliders.push(sphereCollider)
            
            radius = 10
            segments = 16
            rings = 16
            sphere = new THREE.Mesh(
                new THREE.SphereGeometry(radius,segments,rings),
                new THREE.MeshBasicMaterial({
                    color: 0x53aabb
                    opacity: 0.25
                    transparent: true
                    wireframe: true
                })
            )
            sphere.visible = false
            sphere.vertexIndex = i
            sphere.position.x = vertice.x
            sphere.position.y = vertice.y
            #sphere.castShadow = true;
            #sphere.receiveShadow = true;
            @linea.add(sphere)

            # registro le collisioni sulle sfere
            mc = THREE.CollisionUtils.MeshColliderWBox(sphere)
            THREE.Collisions.colliders.push(mc)
            
        particleSystem = new THREE.ParticleSystem(
            particles,
            pMaterial
        )

        line.add(particleSystem)


        @material = new THREE.MeshLambertMaterial({
            color: 0x8866ff
            blending: 3
            shading: 1
        })

        @mesh = new THREE.Mesh(
            shape.extrude({
                amount:10,
                bevelEnabled:false,
                material: @material,
                extrudeMaterial: @material
            }),
            @material
        )


        @world.add( @mesh )

