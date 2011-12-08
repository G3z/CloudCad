###
# CameraController Class #

CameraController Class is used to filter events such as mousemove o mousedown and present them in a meaningfull way to the system
###
define( 
    "views/CameraController",
    ()->
        class CC.views.CameraController extends Spine.Module 
            @extend(Spine.Events)

            constructor:(@stage3d)->
                @keyboard = @stage3d.keyboard
                @mouse = @stage3d.mouse
                @canvas = @stage3d.canvas

                @STATE = { NONE : -1, ACTIVE : 0 }
                #debugger
                @screen = { 
                    width: window.innerWidth
                    height: window.innerWidth-40        ## Da rendere dinamico
                    offsetLeft: 0
                    offsetTop: 40                       ## Da rendere dinamico
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
                @_wheelDelta = 1.0

                @_panStart = new THREE.Vector2()
                @_panEnd = new THREE.Vector2()

                Spine.bind 'mouse:btn1_down', =>
                    @mouseDown()

                Spine.bind 'mouse:btn1_drag', =>
                    @mouseDrag()

                Spine.bind 'mouse:btn3_drag', =>
                    @mouseDrag()

                Spine.bind 'mouse:btn1_up', =>
                    @mouseUp()

                Spine.bind 'mouse:wheel_changed', =>
                    @mouseWheel()
                #debugger

            getMouseOnScreen:( x, y ) =>
                return new THREE.Vector2(
                    x / @radius * 0.5,
                    y / @radius * 0.5
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

                @_eye.copy( @stage3d.camera.position ).subSelf( @target )

                projection = @stage3d.camera.up.clone().setLength( mouseOnBall.y )
                projection.addSelf( @stage3d.camera.up.clone().crossSelf( @_eye ).setLength( mouseOnBall.x ) )
                projection.addSelf( @_eye.setLength( mouseOnBall.z ) )
                return projection

            rotateCamera:=>
                angle = Math.acos( @_rotateStart.dot( @_rotateEnd ) / @_rotateStart.length() / @_rotateEnd.length() )

                if angle
                    axis = ( new THREE.Vector3() ).cross( @_rotateStart, @_rotateEnd ).normalize()
                    quaternion = new THREE.Quaternion()

                    angle *= @rotateSpeed

                    quaternion.setFromAxisAngle( axis, -angle )
                    quaternion.multiplyVector3( @_eye )
                    quaternion.multiplyVector3( @stage3d.camera.up )
                    quaternion.multiplyVector3( @_rotateEnd )

                    if @staticMoving
                        @_rotateStart = @_rotateEnd
                    else
                        quaternion.setFromAxisAngle( axis, angle * ( @dynamicDampingFactor - 1.0 ) )
                        quaternion.multiplyVector3( @_rotateStart )
                

            zoomCamera:=>
                factor = 1.0 + ( @_zoomEnd.y - @_zoomStart.y ) * @zoomSpeed
                if factor != 1.0 and factor > 0.0
                    @_eye.multiplyScalar( factor )
                    if ( @staticMoving )
                        @_zoomStart = @_zoomEnd
                    else
                        @_zoomStart.y += ( @_zoomEnd.y - @_zoomStart.y ) * @dynamicDampingFactor
            panCamera :=>
                mouseChange = @_panEnd.clone().subSelf( @_panStart )

                if mouseChange.lengthSq()
                    mouseChange.multiplyScalar( @_eye.length() * @panSpeed )

                    pan = @_eye.clone().crossSelf( @stage3d.camera.up ).setLength( mouseChange.x )
                    pan.addSelf( @stage3d.camera.up.clone().setLength( mouseChange.y ) )

                    @stage3d.camera.position.addSelf( pan )
                    @target.addSelf( pan )

                    if @staticMoving
                        @_panStart = @_panEnd
                    else
                        @_panStart.addSelf( mouseChange.sub( @_panEnd, @_panStart ).multiplyScalar( @dynamicDampingFactor ) )            

            checkDistances:=>
                unless @noZoom or @noPan
                    if  @stage3d.camera.position.lengthSq()>@maxDistance*@maxDistance
                        @stage3d.camera.position.setLength( @maxDistance )

                    if @_eye.lengthSq()<@minDistance*@minDistance
                        @stage3d.camera.position.add( @target, @_eye.setLength( @minDistance ) )

            update:=>
                @_eye.copy( @stage3d.camera.position ).subSelf( @target )
                @rotateCamera()

                unless @noZoom
                    @zoomCamera()

                unless @noPan
                    @panCamera()
                
                unless @stage3d.camera.inPersepectiveMode 
                    @stage3d.camera.distance = @stage3d.camera.position.distanceTo(@target)
                    @stage3d.camera.toOrthographic()
                    
                @stage3d.camera.position.add( @target, @_eye )
                @checkDistances()
                @stage3d.camera.lookAt( @target )
                @stage3d.camera.rotationAutoUpdate = true

            mouseDown:=>
                if @_state == @STATE.NONE
                    @_state = @STATE.ACTIVE
                    if (@mouse.btn1.down and @keyboard.isKeyDown("alt") and @keyboard.isKeyDown("shift")) or @mouse.btn2.down
                        @_panStart = @_panEnd = @getMouseOnScreen( @mouse.currentPos.x,@mouse.currentPos.y )

                    else if (@mouse.btn1.down and @keyboard.isKeyDown("alt") and @keyboard.isKeyDown("ctrl")) or (@mouse.btn2.down and @keyboard.isKeyDown("shift"))
                        @_zoomStart = @_zoomEnd = @getMouseOnScreen( @mouse.currentPos.x,@mouse.currentPos.y )

                    else if (@mouse.btn1.down and @keyboard.isKeyDown("alt")) or ( @mouse.btn2.down and @keyboard.isKeyDown("alt"))
                        @_rotateStart = @_rotateEnd = @getMouseProjectionOnBall( @mouse.currentPos.x,@mouse.currentPos.y )

            mouseDrag:=>
                if @_keyPressed
                    @_rotateStart = @_rotateEnd = @getMouseProjectionOnBall( event.clientX, event.clientY )
                    @_zoomStart = @_zoomEnd = @getMouseOnScreen( event.clientX, event.clientY )
                    @_panStart = @_panEnd = @getMouseOnScreen( event.clientX, event.clientY )
                    @_keyPressed = false
                if @_state == @STATE.NONE
                    return
                else if (@mouse.btn1.down and @keyboard.isKeyDown("alt") and @keyboard.isKeyDown("shift")) or @mouse.btn2.down
                    @_panEnd = @getMouseOnScreen( @mouse.currentPos.x,@mouse.currentPos.y )

                else if (@mouse.btn1.down and @keyboard.isKeyDown("alt") and @keyboard.isKeyDown("ctrl")) or (@mouse.btn2.down and @keyboard.isKeyDown("shift"))
                    @_zoomEnd = @getMouseOnScreen( @mouse.currentPos.x,@mouse.currentPos.y )

                else if (@mouse.btn1.down and @keyboard.isKeyDown("alt")) or ( @mouse.btn2.down and @keyboard.isKeyDown("alt"))
                    @_rotateEnd = @getMouseProjectionOnBall( @mouse.currentPos.x,@mouse.currentPos.y )
            
            normalTo:(plane)=>
                if plane.class == "Plane3D"
                    distance = @stage3d.camera.position.distanceTo(@target)
                    @target = plane.position.clone()

                    @stage3d.camera.position.copy(@target)
                    @stage3d.camera.up = plane.up.clone()
                    @stage3d.camera.rotationAutoUpdate = false

                    normal = plane.normal.clone()
                    normal.multiplyScalar(-1).multiplyScalar(distance)
                    @stage3d.camera.position.subSelf(normal)

            toFrontView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,1,0)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.z += distance
            
            toBackView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,1,0)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.z -= distance

            toTopView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,0,-1)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.y += distance

            toBottomView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,0,1)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.y -= distance

            toLeftView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,1,0)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.x += distance

            toRightView:=>
                distance = @stage3d.camera.position.distanceTo(@target)
                @stage3d.camera.position.copy(@target)
                @stage3d.camera.up = new THREE.Vector3(0,1,0)
                @stage3d.camera.rotationAutoUpdate = false
                @stage3d.camera.position.x -= distance

            mouseUp:=>
                @_state = @STATE.NONE

            mouseWheel:=>
                #console.log "qui"
                @factor = @mouse.wheel.speed
                #console.log @_wheelDelta
)

