class CC.views.draw.Camera #extends THREE.CombinedCamera
    #constructor: (angle, ratio, nearClipDist, farClipDist)->
    #    super(angle,ratio,nearClipDist,farClipDist)
    constructor:(left, right,fov,pNear,pFar, oNear, oFar)->
        @threeCamera = new THREE.CombinedCamera(left, right,fov,pNear,pFar, oNear, oFar)
        