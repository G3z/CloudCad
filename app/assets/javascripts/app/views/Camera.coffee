
define(
    "views/Camera",
    ()->
        class CC.views.draw.Camera extends THREE.Camera
            constructor:(@width, @height,@fov,@pNear,@pFar, @oNear, @oFar)->
                super()
                
                @left = -@width / 2
                @right = @width / 2
                @top = @height / 2
                @bottom = -@height / 2

                @cameraO = new THREE.OrthographicCamera( @width / - 2, @width / 2, @height / 2, @height / - 2,  @oNear, @oFar );
                @cameraP = new THREE.PerspectiveCamera( @fov, @width/@height, @pNear, @pFar );
                
                @zoom = 1
                
                @toPerspective()

                @aspect = @width/@height
            
            toPerspective:=>
                @near = @cameraP.near;
                @far = @cameraP.far;
                @cameraP.fov =  @fov / @zoom ;
                @cameraP.updateProjectionMatrix();
                @projectionMatrix = @cameraP.projectionMatrix;
                
                @inPersepectiveMode = true;
                @inOrthographicMode = false;    
            
            toOrthographic:=>
                fov = @fov
                aspect = @aspect
                near = @pNear
                far = @pFar

                hyperfocus = ( near + far ) / 2 
                
                halfHeight = Math.tan( @fov / 2 ) * hyperfocus
                planeHeight = 2 * halfHeight
                planeWidth = planeHeight * aspect
                halfWidth = planeWidth / 2

                #debugger
                @cameraO.left = @left
                @cameraO.right = @right
                @cameraO.top = @top
                @cameraO.bottom = @bottom
                        
                @cameraO.updateProjectionMatrix()

                @near = @cameraO.near
                @far = @cameraO.far
                @projectionMatrix = @cameraO.projectionMatrix
                
                @inPersepectiveMode = false
                @inOrthographicMode = true
            
            setFov:(@fov)=>    
                if @inPersepectiveMode
                    @toPerspective()
                else
                    @toOrthographic()                
            
            setLens:(focalLength, framesize = 43.25)=>  # 36x24mm
                fov = 2 * Math.atan( framesize / (focalLength * 2))
                fov = 180 / Math.PI * fov
                @setFov(fov)
                return fov
            
            setZoom:(@zoom)=>
                if @inPersepectiveMode
                    @toPerspective()
                else
                    @toOrthographic()

            toggleType:->
                if @inPersepectiveMode
                    @toOrthographic()
                    @perspective = false
                else
                    @toPerspective()
                    @perspective = true
)