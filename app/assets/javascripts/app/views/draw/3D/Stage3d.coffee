S.export(
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
        "views/draw/3D/Axes"
    ],
    (Abstract, Camera, Mouse, Keyboard, CameraController,Path3D,Solid3D,Plane3D,Axes)->
        class Stage3d extends Abstract
            
            ###
            This class represent the Stage area where all the elements are represented
            ###
            
            tagName: "div"
            className: "stage3d"

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
                @tools = {}
                @snapTolerance = 15
                @size=
                    w: window.innerWidth
                    h: window.innerHeight-2
                # Renderer
                @canvas = document.createElement( 'canvas' )
                $(@canvas).attr("id","canvas3d")
                if glOrNot == "canvas"
                    @renderer =new THREE.CanvasRenderer
                        canvas:@canvas
                else if glOrNot == "svg"
                    @renderer = new THREE.SVGRenderer 
                        canvas: @canvas
                else
                    @renderer = new THREE.WebGLRenderer
                        antialias: true
                        canvas: @canvas
                        clearColor: 0x111188
                        clearAlpha: 0.2
                        maxLights: 4
                        #stencil: true
                        preserveDrawingBuffer: true
                        sortObjects:true
                    
                    #@renderer.setFaceCulling("back","cw")

                # scena
                @scene = new THREE.Scene()
                @projector = new THREE.Projector()

                @world = new THREE.Object3D()
                @scene.add(@world)

                # Setup camera
                @camera = new Camera(@size.w,@size.h,35, 0.1, 150000,0.1, 150000)
                @camera.position.z = 1500
                @scene.add(@camera)

                # Luci
                @light1 = new THREE.DirectionalLight(0xFFFFFF,1.0,1000)
                @light1.position.set( 1, 1, 0.6 )
                @scene.add( @light1 )

                @light2 = new THREE.DirectionalLight(0xFFFFFF,0.8,1000)
                @light2.position.set( 1, 1, -1 )
                @scene.add( @light2 )

                @light3 = new THREE.DirectionalLight(0xFFFFFF,0.5,1000)
                @light3.position.set( -1, -1, -0.6 )
                @scene.add( @light3 )

                # Add ambient light
                @ambientLight = new THREE.AmbientLight( 0xffffff )
                @scene.add(@ambientLight)
                

                # piano per le interazioni della camera
                @actionPlane = new THREE.Mesh( new THREE.PlaneGeometry( 2000, 2000, 2, 2 ), new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 0.25, transparent: false, wireframe: true } ) )
                @actionPlane.lookAt( @camera.position )
                @actionPlane.visible = false
                @scene.add(@actionPlane)
                
                @mouse = new Mouse($(@canvas))
                @keyboard = new Keyboard()

                @cameraController = new CameraController(this)
                @cameraController.movementSpeed = 75
                @cameraController.lookSpeed = 0.125
                @cameraController.lookVertical = false


                # Define rendere size
                @renderer.setSize( @size.w,@size.h )
                @renderer.sortObjects = false
                @renderer.shadowMapEnabled = true
                @renderer.shadowMapSoft = true

                @renderer.shadowCameraNear = 3
                @renderer.shadowCameraFar = @camera.far
                @renderer.shadowCameraFov = 50

                @renderer.shadowMapBias = 0.0039
                @renderer.shadowMapDarkness = 0.5
                @renderer.shadowMapWidth = 1024
                @renderer.shadowMapHeight = 1024
                # Add the element to the DOM
                $(@el).append(@renderer.domElement)

                window.stage3d = this
                @layers= {}
                @createGeom()

                # Event listeners
                # Mouse events
                $(window)
                    .bind  'resize',
                        @windowResize

                $(document)
                    .bind 'mouse:btn1_down', =>
                        unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                            @activeTool.mouseDown()

                    .bind 'mouse:btn1_drag', =>
                        unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                            @activeTool.mouseDragged()

                    .bind 'mouse:btn1_up', =>
                        unless @keyboard.isKeyDown("shift") or @keyboard.isKeyDown("alt") or @keyboard.isKeyDown("ctrl")
                            @activeTool.mouseUp()

                    .bind 'keyboard:c_up', =>
                        @camera.toggleType()
                    
                    .bind 'keyboard:n_up', =>
                        if @activeTool?.activePlane?.class = "Plane3D"
                            @cameraController.normalTo(@activeTool.activePlane)

                    .bind 'keyboard:1_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toFrontView()

                    .bind 'keyboard:2_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toBackView()

                    .bind 'keyboard:3_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toTopView()

                    .bind 'keyboard:4_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toBottomView()

                    .bind 'keyboard:5_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toLeftView()

                    .bind 'keyboard:6_up', =>
                        if @keyboard.isKeyDown("alt")
                            @cameraController.toRightView()

                    .bind 'keyboard:spacebar_up', =>
                        if @selectedObject?
                            @selectedObject.toggleSelection?()
                        @selectedObject = undefined
                        if @tools.selectTool?
                            @tools.selectTool.do()

                super()
                $(@el).append(@canvas)
            
            startLoops:=>
                @graphicLoop()
                @logicLoop()

            graphicLoop:->
                stage3d = window.stage3d
                render=(stage3d)->
                    stage3d.cameraController.update()
                    #@actionPlane.lookAt( @camera.position )
                    stage3d.renderer.render(stage3d.scene,stage3d.camera)
                requestAnimationFrame(stage3d.graphicLoop)
                render(stage3d)

            logicLoop:->
                stage3d = window.stage3d
                check=(obj,stage3d)->
                    for object in obj
                        unless object.parent?
                            stage3d.layers[object.layer].remove(object)
                        if obj.selected? and obj.id?
                            if obj.selected
                                unless obj.id = stage3d.selectedObject.id
                                    obj.toggleSelection()
                for layer of stage3d.layers
                    check(stage3d.layers[layer],stage3d) 
                setTimeout(stage3d.logicLoop,1000)

            windowResize:=>
                @size=
                    w: window.innerWidth
                    h: window.innerHeight-5

                @renderer.setSize( @size.w, @size.h )

                @camera.width  = @size.w
                @camera.height = @size.h
                
                @camera.update()
                
            createGeom:=>
                @planeZ = new Plane3D({
                    color: 0x0000AA
                    layer:"originPlanes"
                })
                
                @planeY = new Plane3D({
                    rotation: new THREE.Vector3(Math.toRadian(-90),0,0)
                    size:
                        w:600
                        h:600
                    color: 0x00AA00
                    layer:"originPlanes"
                })
                
                @planeX = new Plane3D({
                    rotation: new THREE.Vector3(0,Math.toRadian(90),0)
                    color: 0xAA0000
                    layer:"originPlanes"
                })

                @world.add(@planeX)
                @world.add(@planeY)
                @world.add(@planeZ)
        
        # Singleton
        new Stage3d()
)

