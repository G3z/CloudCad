###
# ThreeMouse Class#

ThreeMouse Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###

class CC.views.draw.ThreeMouse extends Spine.Module 
    @extend(Spine.Events)
    
    ###
        When this class is created it disables right-mouse context menu so that it's possible to use that mouse button
    ###

    constructor:(@camera,@domElement)->
        @STATE = { NONE : -1, ROTATE : 0, ZOOM : 1, PAN : 2 }
        @screen = { 
            width: window.innerWidth
            height: window.innerHeight
            offsetLeft: 0
            offsetTop: 0
        }
        @radius = ( @screen.width + @screen.height ) / 4

        @rotateSpeed = 1.0
        @zoomSpeed = 1.2
        @panSpeed = 0.3

        @noZoom = false
        @noPan = false

        @staticMoving = false
        @dynamicDampingFactor = 0.2

        @minDistance = 0
        @maxDistance = Infinity

        @keys = [ 65 , 83 , 68 ] # A , S , D #

        @target = new THREE.Vector3( 0, 0, 0 )

        @_keyPressed = false
        @_state = @STATE.NONE

        @_eye = new THREE.Vector3()

        @_rotateStart = new THREE.Vector3()
        @_rotateEnd = new THREE.Vector3()

        @_zoomStart = new THREE.Vector2()
        @_zoomEnd = new THREE.Vector2()

        @_panStart = new THREE.Vector2()
        @_panEnd = new THREE.Vector2()

        #debugger
        @domElement.bind('contextmenu', ( event )=>
            event.preventDefault()
        )

        @domElement.bind( 'mousemove', (event) =>
            @mouseMove(event)
        )
        @domElement.bind( 'mousedown', ( event )=>
            @mouseDown(event)
        )
        @domElement.bind( 'mouseup', (event)=>
            @mouseUp(event)
        )

        $(window).bind( 'keydown', (event)=>
            @keyDown(event)
        )
        $(window).bind( 'keyup',   (event)=>
            @keyUp(event)
        )
        
    handleEvent:( event )=>
        if typeof this[ event.type ] == 'function'  
            this[ event.type ]( event )

    getMouseOnScreen:( clientX, clientY ) =>
        return new THREE.Vector2(
            ( clientX - @screen.offsetLeft ) / @radius * 0.5,
            ( clientY - @screen.offsetTop ) / @radius * 0.5
        )

    getMouseProjectionOnBall:( clientX, clientY )=>
        mouseOnBall = new THREE.Vector3(
            ( clientX - @screen.width * 0.5 - @screen.offsetLeft ) / @radius,
            ( @screen.height * 0.5 + @screen.offsetTop - clientY ) / @radius,
            0.0
        )
        
        length = mouseOnBall.length()

        if length > 1.0
            mouseOnBall.normalize()
        else
            mouseOnBall.z = Math.sqrt( 1.0 - length * length )

        @_eye.copy( @camera.position ).subSelf( @target )

        projection = @camera.up.clone().setLength( mouseOnBall.y )
        projection.addSelf( @camera.up.clone().crossSelf( @_eye ).setLength( mouseOnBall.x ) )
        projection.addSelf( @_eye.setLength( mouseOnBall.z ) )

        return projection

    rotateCamera:()=>

        angle = Math.acos( @_rotateStart.dot( @_rotateEnd ) / @_rotateStart.length() / @_rotateEnd.length() )
        if angle
            axis = ( new THREE.Vector3() ).cross( @_rotateStart, @_rotateEnd ).normalize()
            quaternion = new THREE.Quaternion()
            
            angle *= @rotateSpeed

            quaternion.setFromAxisAngle( axis, -angle )
            quaternion.multiplyVector3( @_eye )
            quaternion.multiplyVector3( @camera.up )
            quaternion.multiplyVector3( @_rotateEnd )

            if @staticMoving
                @_rotateStart = @_rotateEnd
            else
                quaternion.setFromAxisAngle( axis, angle * ( @dynamicDampingFactor - 1.0 ) )
                quaternion.multiplyVector3( @_rotateStart )

    zoomCamera:()=>

        factor = 1.0 + ( @_zoomEnd.y - @_zoomStart.y ) * @zoomSpeed

        if factor != 1.0 and factor > 0.0
            @_eye.multiplyScalar( factor )
            if ( @staticMoving )
                @_zoomStart = @_zoomEnd
            else
                @_zoomStart.y += ( @_zoomEnd.y - @_zoomStart.y ) * @dynamicDampingFactor

    panCamera :()=>

        mouseChange = @_panEnd.clone().subSelf( @_panStart )

        if mouseChange.lengthSq()

            mouseChange.multiplyScalar( @_eye.length() * @panSpeed )

            pan = @_eye.clone().crossSelf( @camera.up ).setLength( mouseChange.x )
            pan.addSelf( @camera.up.clone().setLength( mouseChange.y ) )

            @camera.position.addSelf( pan )
            @target.addSelf( pan )

            if @staticMoving
                @_panStart = @_panEnd
            else
                @_panStart.addSelf( mouseChange.sub( @_panEnd, @_panStart ).multiplyScalar( @dynamicDampingFactor ) )            

    checkDistances:()=>
        unless @noZoom or @noPan
            if  @camera.position.lengthSq()>@maxDistance*@maxDistance
                @camera.position.setLength( @maxDistance )

            if @_eye.lengthSq()<@minDistance*@minDistance
                @camera.position.add( @target, @_eye.setLength( @minDistance ) )

    update:()=>

        @_eye.copy( @camera.position ).subSelf( @target )
        @rotateCamera()
        
        unless @noZoom
            @zoomCamera()

        unless @noPan
            @panCamera()

        @camera.position.add( @target, @_eye )
        @checkDistances()
        @camera.lookAt( @target )

    keyDown:( event )=>

        if @_state != @STATE.NONE
            return

        else if event.keyCode == @keys[ @STATE.ROTATE ]
            @_state = @STATE.ROTATE

        else if event.keyCode == @keys[ @STATE.ZOOM ] and !@noZoom
            @_state = @STATE.ZOOM

        else if event.keyCode == @keys[ @STATE.PAN ] and !@noPan
            @_state = @STATE.PAN

        if @_state != @STATE.NONE
            @_keyPressed = true

    keyUp:( event )=>
        if @_state != @STATE.NONE
            @_state = @STATE.NONE

    mouseDown:( event )=>
        event.preventDefault()
        event.stopPropagation()
        if @_state == @STATE.NONE
            @_state = event.button
            if @_state == @STATE.ROTATE
                @_rotateStart = @_rotateEnd = @getMouseProjectionOnBall( event.clientX, event.clientY )

            else if @_state == @STATE.ZOOM and !@noZoom
                @_zoomStart = @_zoomEnd = @getMouseOnScreen( event.clientX, event.clientY )

            else if !@noPan
                @_panStart = @_panEnd = @getMouseOnScreen( event.clientX, event.clientY )

    mouseMove:( event )=>
        if @_keyPressed
            @_rotateStart = @_rotateEnd = @getMouseProjectionOnBall( event.clientX, event.clientY )
            @_zoomStart = @_zoomEnd = @getMouseOnScreen( event.clientX, event.clientY )
            @_panStart = @_panEnd = @getMouseOnScreen( event.clientX, event.clientY )
            @_keyPressed = false

        if @_state == @STATE.NONE
            return

        else if @_state == @STATE.ROTATE
            @_rotateEnd = @getMouseProjectionOnBall( event.clientX, event.clientY )

        else if @_state == @STATE.ZOOM and !@noZoom
            @_zoomEnd = @getMouseOnScreen( event.clientX, event.clientY )

        else if @_state == @STATE.PAN and !@noPan
            @_panEnd = @getMouseOnScreen( event.clientX, event.clientY )


    mouseUp:( event )=>
        event.preventDefault()
        event.stopPropagation()
        @_state = @STATE.NONE
