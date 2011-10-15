###
    *-- FUNZIONI PER IL MOUSE --*
    Per chiarezza sarebbero da spostare su un altro file
###
class Cad19_Mouse_Button
    constructor:->
        @down = false
        @click = {
            start: {
                x:0
                y:0
            }
            currentPos: {
                x:0
                y:0
            }
            delta: {
                w:0
                h:0
            }
            oldDelta: {
                w:0
                h:0
            }
        }

class Cad19_Mouse
    
    constructor:->
        @rotationScale = 0.003
        @btn1 = new Cad19_Mouse_Button()
        @btn2 = new Cad19_Mouse_Button()
        @btn3 = new Cad19_Mouse_Button()

        $(document.body).attr("oncontextmenu","return false")
        $(document).mousedown( (event)=> @mouseDown({x:event.clientX,y:event.clientY},event.which) )

        $(document).mousemove( (event)=> @mouseDragged({x:event.clientX,y:event.clientY},event.which) )

        $(document).mouseup( (event)=>  @mouseUp({x:event.clientX,y:event.clientY},event.which) )

    mouseDown:(point,button)->

        if button == 1                          #click sinistro
            @btn1.down = true
            @btn1.click.start = point
            @btn1.click.currentPos = point

        if button == 2                          #click centrale
            @btn2.down = true
            @btn2.click.start = point
            @btn2.click.currentPos = point

        if button == 3                          #click centrale
            @btn3.down = true
            @btn3.click.start = point
            @btn3.click.currentPos = point

    mouseDragged:(point,button)->   
        if button ==1 && @btn1.down
            @btn1.click.currentPos = point
            @btn1.click.delta = {
                w:@btn1.click.oldDelta.w + point.x - @btn1.click.start.x
                h:@btn1.click.oldDelta.h + point.y - @btn1.click.start.y
            }

        if button ==2 && @btn2.down
            @btn2.click.currentPos = point
            @btn2.click.delta = {
                w:@btn2.click.oldDelta.w + point.x - @btn2.click.start.x
                h:@btn2.click.oldDelta.h + point.y - @btn2.click.start.y
            }

        if button ==3 && @btn3.down
            @btn3.click.currentPos = point
            @btn3.click.delta = {
                w:@btn3.click.oldDelta.w + point.x - @btn3.click.start.x
                h:@btn3.click.oldDelta.h + point.y - @btn3.click.start.y
            }

    mouseUp:(point,button)->
        if button == 1 && @btn1.down
            @btn1.down =false
            @btn1.click.oldDelta = @btn1.click.delta

        if button == 2 && @btn2.down
            @btn2.down =false
            @btn3.click.oldDelta = @btn3.click.delta

        if button == 3 && @btn3.down
            @btn3.down =false
            @btn3.click.oldDelta = @btn3.click.delta
    
    rotationX:=>
        @btn3.click.delta.h * @rotationScale
    rotationY:=>
        @btn3.click.delta.w * @rotationScale

class Cad19   
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
        @mouse = new Cad19_Mouse()
        @camera = new THREE.PerspectiveCamera( 35, (window.innerWidth-50) / (window.innerHeight-50), 1, 10000 )
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
    

cadView = new Cad19()
cadView.animate()

