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
   

    constructor:(@glOrNot)->
        super()
        @rotationScale = 0.003
        @zoomScale = 4
        @zoom = 1
        @lastvert =0

        # Setup camera
        #camera = new CC.views.draw.Camera(35, (window.innerWidth-50) / (window.innerHeight-50), 1, 15000)
        @camera = new CC.views.draw.Camera((window.innerWidth-50),(window.innerHeight-50),35, 1, 15000,1, 15000).threeCamera
        @camera.position.z = 1000 * @zoom

        # Create the real Scene
        @scene = new THREE.Scene()

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
        canvas = document.createElement( 'canvas' )
        $(canvas).attr("id","canvas3d")
        if glOrNot == "canvas"
            @renderer =new THREE.CanvasRenderer({canvas:canvas})
        else if glOrNot == "svg"
            @renderer =new THREE.SVGRenderer({canvas:canvas})
        else
            @renderer = new THREE.WebGLRenderer({
                antialias: true
                canvas: canvas
                clearColor: 0x111188
                clearAlpha: 0.2
                maxLights: 4
                stencil: true
                preserveDrawingBuffer: false
            })
            #@renderer.setFaceCulling("back","cw")

        # Define rendere size
        @renderer.setSize( window.innerWidth-50, window.innerHeight-50 )

        # Add the element to the DOM
        document.body.appendChild( @renderer.domElement )
        
        # Handle mouse events
        @mouse = new CC.views.draw.Mouse()
        @createGeom()
        
        Spine.bind 'mouse:wheel_changed', =>
            @updateCameraZoom() 

        #Spine.bind 'mouse:btn1_down', =>
        #    @createGeom() 

    animate:=>
        requestAnimFrame(@animate)
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

        @camera.position.z += 1 * multiplier * @mouse.wheel.speed * @zoomScale

    createGeom:=>
        @vertices =[
            new THREE.Vector2(0,0)
            new THREE.Vector2(100,0)
            new THREE.Vector2(100,100)
            new THREE.Vector2(0,100)
            new THREE.Vector2(0,0)
        ]
        color = 0x8866ff
        x=0
        y=0
        z=0
        rx=0
        ry=0
        rz=0
        s=1 
        shape = new THREE.Shape(@vertices)
        points = shape.createPointsGeometry()

        line = new THREE.Line( points, new THREE.LineBasicMaterial( { color: color, linewidth: 2 } ) );
        line.position.set( x, y, z + 25 );
        line.rotation.set( rx, ry, rz );
        line.scale.set( s, s, s );
        @world.add( line );

        line = new THREE.Line( points, new THREE.LineBasicMaterial( { color: color, opacity: 0.5 } ) );
        line.position.set( x, y, z + 75 );
        line.rotation.set( rx, ry, rz );
        line.scale.set( s, s, s );
        @world.add( line );
        
        pgeo = THREE.GeometryUtils.clone( points );
        particles = new THREE.ParticleSystem( pgeo, new THREE.ParticleBasicMaterial( { color: color, size: 3, opacity: 0.75 } ) );
        particles.position.set( x, y, z + 75 );
        particles.rotation.set( rx, ry, rz );
        particles.scale.set( s, s, s );
        @world.add( particles );

        ###
        @material = new THREE.LineBasicMaterial( { color: 0x8866ff, linewidth: 2 } )

        shape = new THREE.Shape(@vertices)
        mesh = new THREE.Mesh( shape.extrude({amount:10,  material: @material, extrudeMaterial: @material }), @material )
        #@path = new THREE.Path(vertices)
        if @world.children.length > 0
            mesh.position.z = @world.children[@world.children.length-1].position.z -100

        @world.add( mesh )
        ###