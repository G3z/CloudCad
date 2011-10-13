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
        @material = new THREE.MeshLambertMaterial( { color: 0xff0000, wireframe :false } )

        @mesh = new THREE.Mesh( @geometry, @material )
        @scene.add( @mesh )
        
        @light = new THREE.PointLight( 0xFFFF00, .5  )
        @light.position.set( 400, 300, 400 )
        @scene.add( @light )

        @ambientLight = new THREE.AmbientLight( 0xbbbbbb )
        @scene.add( @ambientLight )

        if glOrNot 
            @renderer = new THREE.WebGLRenderer()
        else 
            @renderer =new THREE.WebCanvasRenderer()
        @renderer.setSize( window.innerWidth, window.innerHeight )

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
    

cadView = new Cad19(true)
cadView.animate()