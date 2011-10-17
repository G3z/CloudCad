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
        # Handle mouse events
        @mouse = new CC.views.draw.Mouse()

        # Setup camera
        @camera = new CC.views.draw.Camera(35, (window.innerWidth-50) / (window.innerHeight-50), 1, 10000)
        @camera.position.z = 1000

        # Create the real Scene
        @scene = new THREE.Scene()

        # Create the cube
        @geometry = new THREE.CubeGeometry( 200, 200, 200 )
        @material = new THREE.MeshLambertMaterial( { color: 0x8866ff, wireframe :false } )
        @mesh = new THREE.Mesh( @geometry, @material )
        
        @other_geometry = new THREE.CubeGeometry( 50, 50, 50 )
        @other_material = new THREE.MeshLambertMaterial( { color: 0x2266ff, wireframe :false } )
        @other_mesh = new THREE.Mesh( @other_geometry, @other_material ) 

        @other_mesh.position.set(125,-100+25,0)
        
        @mesh.addChild(@other_mesh)

        @scene.add( @mesh )

        # Add a light
        @light = new THREE.PointLight(0xFFFF00, 0.4)
        @light.position.set( 400, 300, 400 )
        @scene.add( @light )

        # Add ambient light
        @ambientLight = new THREE.AmbientLight( 0x888888, )
        @scene.add(@ambientLight)

        # Setup a renderer
        if glOrNot == "canvas"
            @renderer =new THREE.CanvasRenderer()
        else if glOrNot == "svg"
            @renderer =new THREE.SVGRenderer()
        else
            @renderer = new THREE.WebGLRenderer({
                antialias: true,
                canvas: document.createElement( 'canvas' ),
                clearColor: 0x111188,
                clearAlpha: 0.2,
                maxLights: 4,
                stencil: true,
                preserveDrawingBuffer: true
            })
            #@renderer.setFaceCulling("back","cw")

        # Define rendere size
        @renderer.setSize( window.innerWidth-50, window.innerHeight-50 )

        # Add the element to the DOM
        document.body.appendChild( @renderer.domElement )

    animate:=>
        requestAnimFrame(@animate)
        @render()
    
    render:=>
        @mesh.rotation.x = @mouse.btn3.absoluteDelta.h * @rotationScale
        @mesh.rotation.y = @mouse.btn3.absoluteDelta.w * @rotationScale
        @renderer.render(@scene,@camera)