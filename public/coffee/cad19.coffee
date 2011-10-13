class Cad19
    camera=null
    scene=null
    renderer=null
    geometry=null
    material=null
    mesh=null

    constructor:(@glOrNot)->
        camera = new THREE.PerspectiveCamera( 35, window.innerWidth / window.innerHeight, 1, 10000 )
        camera.position.z = 1000

        scene = new THREE.Scene()

        geometry = new THREE.CubeGeometry( 200, 200, 200 )
        material = new THREE.MeshLambertMaterial( { color: 0xff0000, wireframe :false } )

        mesh = new THREE.Mesh( geometry, material )
        scene.add( mesh )
        
        light = new THREE.PointLight( 0xFFFF00 )
        light.position.set( 400, 300, 400 )
        scene.add( light )

        if glOrNot 
            renderer = new THREE.WebGLRenderer()
        else 
            renderer =new THREE.WebCanvasRenderer()
        renderer.setSize( window.innerWidth, window.innerHeight )

        document.body.appendChild( renderer.domElement )

    animate:->
        requestAnimFrame(cadView.animate)
        cadView.render()
    
    render:->
        #mesh.rotation.x += 0.01
        mesh.rotation.y += 0.02
        renderer.render(scene,camera)


cadView = new Cad19(true)
cadView.animate()