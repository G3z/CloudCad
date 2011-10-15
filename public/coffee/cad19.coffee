class Cad19   
    @camera
    @scene
    @renderer
    @geometry
    @material
    @mesh
    @light
    @ambientLight
    @mouseX
    @mouseY
    @mouseDown
    @origin
    @oldDelta

    constructor:(@glOrNot)->
        @mouseX=1
        @mouseY=1
        @mouseDown=false
        @origin= { x: window.innerWidth/2, y:window.innerHeight/2}
        @oldDelta= { x: 0, y:0}

        @camera = new THREE.PerspectiveCamera( 35, window.innerWidth / window.innerHeight, 1, 10000 )
        @camera.position.z = 1000

        @scene = new THREE.Scene()

        @geometry = new THREE.CubeGeometry( 200, 200, 200 )
        @material = new THREE.MeshLambertMaterial( { color: 0x8866ff, wireframe :false } )

        @mesh = new THREE.Mesh( @geometry, @material )
        @scene.add( @mesh )
        
        @light = new THREE.PointLight( 0xFFFF00, .4  )
        @light.position.set( 400, 300, 400 )
        @scene.add( @light )

        @ambientLight = new THREE.AmbientLight( 0x888888, )
        @scene.add( @ambientLight )

        if glOrNot == "canvas"
            @renderer =new THREE.CanvasRenderer()
        else if glOrNot == "svg"
            @renderer =new THREE.SVGRenderer()
        else
            @renderer = new THREE.WebGLRenderer({
                antialias: true,
                canvas: document.createElement( 'canvas' ),
                clearColor: 0x000000,
                clearAlpha: .1,
                maxLights: 4,
                stencil: true,
                preserveDrawingBuffer: false
            })
            #@renderer.setFaceCulling("back","cw")
        @renderer.setSize( window.innerWidth, window.innerHeight )
        
        ###
            *-- FUNZIONI PER IL MOUSE --*
            Per chiarezza sarebbero da spostare su un altro file
        ###
        $(document).mousedown( (event)-> 
            cadView.mouseDown = true
            cadView.origin.x = event.clientX
            cadView.origin.y = event.clientY
        )

        $(document).mousemove( (event)->
            if cadView.mouseDown
                cadView.mouseX = cadView.oldDelta.x + event.clientX - cadView.origin.x;
                cadView.mouseY = cadView.oldDelta.y + event.clientY - cadView.origin.y;
                
        )

        $(document).mouseup( (event)-> 
            cadView.mouseDown = false
            
            cadView.oldDelta.x = cadView.mouseX
            cadView.oldDelta.y = cadView.mouseY
        )

        document.body.appendChild( @renderer.domElement )

    animate:->
        requestAnimFrame(cadView.animate)
        cadView.render()
    
    render:->
        @mesh.rotation.x = @mouseY * 0.003
        @mesh.rotation.y = @mouseX * 0.003
        @renderer.render(@scene,@camera)
    

window.cadView = new Cad19()
window.cadView.animate()