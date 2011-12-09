define(
    "views/draw/3D/Stage3d"
    [
        "views/Abstract"
        "views/Camera"
        "views/Mouse"
        "views/Keyboard"
        "views/CameraController"
        "views/draw/3D/primitives/Path3D"
        "views/draw/3D/primitives/Solid3D"
        "views/draw/3D/primitives/Plane3D"
    ],
    (Abstract, Camera, Mouse, Keyboard, CameraController,Path3D,Solid3D,Plane3D)->
        class CC.views.draw.Stage3d extends Abstract
            ###
            This class represent the Stage area where all the elements are represented
            ###
            @camera
            @scene
            @renderer
            @geometry
            @material
            @mesh
            @light
            @ambientLight
            @origin
            @selectedObject

            constructor:(@glOrNot)->
                super()
                @tools = {}
                @snapTolerance = 8

                # Renderer
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

                # scena
                @scene = new THREE.Scene()
                @projector = new THREE.Projector()

                @world = new THREE.Object3D()
                @planes = new THREE.Object3D()
                @scene.add(@world)
                @scene.add(@planes)

                # Setup camera
                @camera = new Camera((window.innerWidth),(window.innerHeight-40),35, 1, 15000,1, 15000)
                @camera.position.z = 1000
                @scene.add(@camera)

                # Luci
                @light1 = new THREE.SpotLight(0xFFFFFF,1.0,2.0)
                @light1.position.set( 400, 300, 400 )
                @scene.add( @light1 )

                @light2 = new THREE.SpotLight(0xFFFFFF,0.6,2.0)
                @light2.position.set( 400, 300, -600 )
                @scene.add( @light2 )

                @light3 = new THREE.SpotLight(0xFFFFFF,0.4,2.0)
                @light3.position.set( -400, -300, -600 )
                @scene.add( @light3 )

                # Add ambient light
                @ambientLight = new THREE.AmbientLight( 0xffffff )
                @scene.add(@ambientLight)
                

                # piano per le interazioni della camera
                @cameraPlane = new THREE.Mesh( new THREE.PlaneGeometry( 2000, 2000, 2, 2 ), new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 0.25, transparent: false, wireframe: true } ) )
                @cameraPlane.lookAt( @camera.position )
                @cameraPlane.visible = false
                @scene.add(@cameraPlane)
                
                @mouse = new Mouse($(@canvas))
                @keyboard = new Keyboard()

                @cameraController = new CameraController(this)
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

                window.stage3d = this
                
                @createGeom()

                # Event listeners
                # Mouse events
                Spine.bind 'mouse:btn1_down', =>
                    unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                        @activeTool.mouseDown()
                        
                Spine.bind 'mouse:btn1_drag', =>
                    unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                        @activeTool.mouseDragged()
                
                Spine.bind 'mouse:btn1_up', =>
                    unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                        @activeTool.mouseUp()
                
                #alt + number events
                Spine.bind 'keyboard:c_up', =>
                    @camera.toggleType()

                Spine.bind 'keyboard:1_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toFrontView()

                Spine.bind 'keyboard:2_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toBackView()

                Spine.bind 'keyboard:3_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toTopView()

                Spine.bind 'keyboard:4_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toBottomView()

                Spine.bind 'keyboard:5_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toLeftView()

                Spine.bind 'keyboard:6_up', =>
                    if @keyboard.isKeyDown("alt")
                        @cameraController.toRightView()

                Spine.bind 'keyboard:spacebar_up', =>
                     if @selectedObject?
                        @selectedObject.toggleSelection()
                        @selectedObject = undefined
                        if @tools.selectTool?
                            @tools.selectTool.do()
                
            animate:=>
                requestAnimFrame(@animate)
                @render()

            render:=>
                @cameraController.update()
                @cameraPlane.lookAt( @camera.position );
                @renderer.render(@scene,@camera)

            createGeom:=>
                @planeZ = new Plane3D({
                    rotation: new THREE.Vector3(0,0,0)
                    color: 0x0000aa
                    layer:"scene"
                })
                
                
                @planeY = new Plane3D({
                    rotation: new THREE.Vector3(Math.toRadian(-90),0,0)
                    color: 0x00aa00
                    layer:"scene"  
                })
                
                @planeX = new Plane3D({
                    rotation: new THREE.Vector3(0,Math.toRadian(-90),0)
                    color: 0xaa0000
                    layer:"scene"
                })
                @planes.add(@planeX)
                @planes.add(@planeY)
                @planes.add(@planeZ)
                ###
                vertices =[
                    new THREE.Vector2(0,0)
                    new THREE.Vector2(0,100)
                    new THREE.Vector2(100,100)
                    new THREE.Vector2(100,0)
                    new THREE.Vector2(0,0)
                ]
                @linea = new Path3D({
                    points: vertices
                })
                @linea.position.x = 50

                @linea2 = new Path3D({
                    points: vertices
                })
                @linea2.position.x = -150

                @world.add(@linea)
                @world.add(@linea2)
                ###
)
