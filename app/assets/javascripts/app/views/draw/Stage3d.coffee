
class CC.views.draw.Stage3d extends CC.views.Abstract

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

    constructor:(@glOrNot)->
        super()

        @mouse = new CC.views.draw.Mouse()
        @camera = new THREE.PerspectiveCamera( 35, (window.innerWidth-50) / (window.innerHeight-50), 1, 10000 )
        @camera.position.z = 1000

        @scene = new THREE.Scene()

        @geometry = new THREE.CubeGeometry( 200, 200, 200 )
        @material = new THREE.MeshLambertMaterial( { color: 0x8866ff, wireframe :false } )

        @mesh = new THREE.Mesh( @geometry, @material )
        @scene.add( @mesh )

        @light = new THREE.PointLight(0xFFFF00, 0.4)
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
                clearColor: 0x111188,
                clearAlpha: 0.2,
                maxLights: 4,
                stencil: true,
                preserveDrawingBuffer: true
            })
            #@renderer.setFaceCulling("back","cw")
        @renderer.setSize( window.innerWidth-50, window.innerHeight-50 )

        document.body.appendChild( @renderer.domElement )

    animate:=>
        requestAnimFrame(@animate)
        @render()

    render:=>
        @mesh.rotation.x = @mouse.rotationX()
        @mesh.rotation.y = @mouse.rotationY()
        @renderer.render(@scene,@camera)