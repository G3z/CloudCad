define(
    "views/draw/3D/Stage3d"
    ["views/Abstract", "views/Camera", "views/Mouse", "views/Keyboard", "views/CameraController","views/draw/3D/primitives/Path3D"],
    (Abstract, Camera, Mouse, Keyboard, CameraController,Path3D)->
        class CC.views.draw.Stage3d extends Abstract
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
                @camera = new Camera((window.innerWidth),(window.innerHeight-40),35, 1, 15000,1, 15000)
                @camera.position.z = 1000 * @zoom
                @scene.add(@camera)
                #@camera.lookAt(@world)
                #@mouse = new CC.views.draw.Mouse(@camera)

                # Add a light
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
                        #debugger
                        c = ray.intersectObject(@world)
                        #console.log c
                        #debugger
                        if c? and c.length>0
                            if c[0].object? and c[0].object != @cameraPlane
                                obj = c[0].object
                                if @selectedMesh?
                                    @selectedMesh.material.color.setHex(0x53aabb)
                                #debugger
                                obj.material.color.setHex(0x0000bb)
                                @selectedMesh = obj
                                intersects = ray.intersectObject( @cameraPlane )
                                @offset.copy( intersects[ 0 ].point ).subSelf( @cameraPlane.position )
                            else
                                @selectedMesh = null
                        else
                            @selectedMesh = null

                Spine.bind 'keyboard:67_up', =>
                    @camera.toggleType()

                Spine.bind 'keyboard:49_up', =>
                    if @keyboard.isKeyDown("alt")
                        @camera.toFrontView()

                Spine.bind 'mouse:btn1_up', =>
                    if @selectedMesh?
                        @selectedMesh.material.color.setHex(0x53aabb)

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
                        if intersects[0]? and @selectedMesh.placeholder==true
                            idx = intersects[0].idx
                            intersects[0].object.position.copy(@selectedMesh.position)
                        #if intersects[0]?
                            newPoint = intersects[0].point.clone()
                            @selectedMesh.position.x = newPoint.x
                            @selectedMesh.position.y = newPoint.y

                            @linea.movePoint(@selectedMesh.vertexIndex , @selectedMesh.position)
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
                    new THREE.Vector2(0,100)
                    new THREE.Vector2(100,100)
                    new THREE.Vector2(100,0)
                    new THREE.Vector2(0,0)
                ]
                @linea = new Path3D({
                    points: @vertices
                })
                @world.add(@linea.threePath)
)
