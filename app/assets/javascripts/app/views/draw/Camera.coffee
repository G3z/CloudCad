class CC.views.draw.Camera extends THREE.PerspectiveCamera
    constructor: (angle, ratio, nearClipDist, farClipDist)->
        super(angle,ratio,nearClipDist,farClipDist)
    #constructor: (left, right,fov,pNear,pFar, oNear, oFar)->
    #    super(left, right,fov,pNear,pFar, oNear, oFar)
        