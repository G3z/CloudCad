class CC.views.draw.Camera extends THREE.Camera
    #constructor: (angle, ratio, nearClipDist, farClipDist)->
    #    super(angle,ratio,nearClipDist,farClipDist)
    constructor:(width, height,fov,pNear,pFar, oNear, oFar)->
        #@threeCamera = new THREE.CombinedCamera(left, right,fov,pNear,pFar, oNear, oFar)
        @perspective = true
        THREE.Camera.call( this );

        @cameraO = new THREE.OrthographicCamera( width / - 2, width / 2, height / 2, height / - 2,  oNear, oFar );
        @cameraP = new THREE.PerspectiveCamera( fov, width/height, pNear, pFar );

        @toPerspective()
    
    toPerspective:=>
        @near = @cameraP.near
        @far = @cameraP.far
        @projectionMatrix = @cameraP.projectionMatrix
    
    toOrthographic:=>
        @near = @cameraO.near
        @far = @cameraO.far
        @projectionMatrix = @cameraO.projectionMatrix
    
    setFov:(fov)=>
        @cameraP.fov = fov
        @cameraP.updateProjectionMatrix()
        @toPerspective()
    
    setLens:(focalLength, framesize = 43.25)=>  # 36x24mm

        fov = 2 * Math.atan( framesize / (focalLength * 2))
        fov = 180 / Math.PI * fov
        @setFov(fov)

        return fov;


    toggleType:->
        if @perspective
            @toOrthographic()
            @perspective = false
        else
            @toPerspective()
            @perspective = true
