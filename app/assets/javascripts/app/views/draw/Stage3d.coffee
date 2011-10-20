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
        @zoom = 1
        # Handle mouse events
        @mouse = new CC.views.draw.Mouse()

        # Setup camera
        @camera = new CC.views.draw.Camera(35, (window.innerWidth-50) / (window.innerHeight-50), 1, 15000)
        
        @camera.position.z = 1000 * @zoom

        # Create the real Scene
        @scene = new THREE.Scene()

        # Create the cube
        @geometry = new THREE.Geometry()
        
        @geometry.vertices =[
            new THREE.Vertex( new THREE.Vector3(0,0,0) )
            new THREE.Vertex( new THREE.Vector3(200,0,0))
            new THREE.Vertex( new THREE.Vector3(200,150,0))
            new THREE.Vertex( new THREE.Vector3(0,100,0))
            #new THREE.Vertex( new THREE.Vector3(0,0,0))
        ]
        @geometry.dynamic = true

        @material = new THREE.LineBasicMaterial( { color: 0x8866ff, wireframe :false } )
        @mesh = new THREE.Line( @geometry, @material )
        @mesh.dynamic = true

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
                preserveDrawingBuffer: false
            })
            #@renderer.setFaceCulling("back","cw")

        # Define rendere size
        @renderer.setSize( window.innerWidth-50, window.innerHeight-50 )

        # Add the element to the DOM
        document.body.appendChild( @renderer.domElement )
        Spine.bind 'mouse:btn1_click', =>
            @createGeom() 

    animate:=>
        requestAnimFrame(@animate)
        @render()
    
    render:=>
        @mesh.rotation.x = @mouse.btn3.absoluteDelta.h * @rotationScale
        @mesh.rotation.y = @mouse.btn3.absoluteDelta.w * @rotationScale
        @renderer.render(@scene,@camera)
        @mesh.geometry.__dirtyVertices = true

    createGeom:=>
        newVertX = @mouse.currentPos.x - window.innerWidth/2
        newVertY = @mouse.currentPos.y - window.innerHeight/2
        
        @mesh.geometry.vertices.push new THREE.Vertex new THREE.Vector3 newVertX,newVertY,0
        @mesh.geometry.__dirtyNormals = true
        @mesh.geometry.__dirtyVertices = true
        @mesh.update()
        console.log @mesh
