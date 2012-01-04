S.export(
    "views/draw/3D/primitives/Plane3D"
    [
        "views/draw/3D/primitives/Primitive"
    ],
    (Primitive)->
        class Plane3D extends Primitive
            constructor:(attr)->
                super()
                @matrixAutoUpdate = true
                defaults = {
                    position : new THREE.Vector3()
                    rotation : new THREE.Vector3()
                    size:
                        w:600
                        h:400
                    normalSize: 100
                    color : 0xaa0000
                }
                unless attr?
                    @position = defaults.position
                    rotation = defaults.rotation
                    size = defaults.size
                    normalSize = defaults.normalSize
                    @color = defaults.color
                else
                    if attr.position? then @position = attr.position else @position = defaults.position
                    if attr.rotation? then rotation = attr.rotation else rotation = defaults.rotation
                    if attr.size? then size = attr.size else size = defaults.size
                    if attr.normalSize? then normalSize = attr.normalSize else normalSize = defaults.normalSize
                    if attr.color? then @color = attr.color else @color = defaults.color
                
                @rotation.x = Math.round(rotation.x*1000)/1000
                @rotation.y = Math.round(rotation.y*1000)/1000
                @rotation.z = Math.round(rotation.z*1000)/1000

                @points=[
                    new THREE.Vector2(size.w/2*-1,size.h/2*-1)
                    new THREE.Vector2(size.w/2*-1,size.h/2)
                    new THREE.Vector2(size.w/2,size.h/2)
                    new THREE.Vector2(size.w/2,size.h/2*-1)
                    new THREE.Vector2(size.w/2*-1,size.h/2*-1)
                ]

                @perimetralLine = new THREE.Line(
                        new THREE.CurvePath.prototype.createGeometry(@points),
                        new THREE.LineBasicMaterial
                            color: @color
                            linewidth: 1.5
                            blending: THREE.AdditiveAlphaBlending
                    )
                @horizontalLine = new THREE.Line(
                        new THREE.CurvePath.prototype.createGeometry([new THREE.Vector2(size.w/2*-1,0),new THREE.Vector2(size.w/2,0)]),
                        new THREE.LineBasicMaterial
                            color: @color
                            linewidth: .6
                            blending: THREE.AdditiveAlphaBlending
                    )
                @verticalLine = new THREE.Line(
                        new THREE.CurvePath.prototype.createGeometry([new THREE.Vector2(0,size.h/2*-1),new THREE.Vector2(0,size.h/2)]),
                        new THREE.LineBasicMaterial
                            color: @color
                            linewidth: .6
                            blending: THREE.AdditiveAlphaBlending
                    )
                @normalLine = new THREE.Line(
                        new THREE.CurvePath.prototype.createGeometry([new THREE.Vector2(0,0),new THREE.Vector2(normalSize,0)]),
                        new THREE.LineBasicMaterial
                            color: @color
                            linewidth: 2
                            blending: THREE.AdditiveAlphaBlending
                    )
                

                #@add @verticalLine
                #@add @horizontalLine
                @add @perimetralLine
                @add @normalLine
                @normalLine.rotation = new THREE.Vector3(0,Math.toRadian(90),0)
                @graphicPlane = new THREE.Mesh( new THREE.PlaneGeometry( size.w, size.h, 2, 2 ), new THREE.MeshBasicMaterial( { 
                                color: @color
                                opacity: 0.04
                                transparent: true
                                wireframe: false
                                blending: THREE.AdditiveAlphaBlending
                            }))
                @logicPlane = new THREE.Mesh( new THREE.PlaneGeometry( 3000, 3000, 2, 2 ), new THREE.MeshBasicMaterial( { 
                                color: @color
                                opacity: 0.0
                                transparent: true
                                wireframe: true
                                
                            }))
                @graphicPlane.doubleSided=true
                
                @updateMatrix()
                @up = @matrix.multiplyVector3(@up.clone())
                @up.subSelf(@position)

                @normal = @matrix.multiplyVector3(@logicPlane.geometry.faces[0].normal.clone())
                @normal.subSelf(@position)
                @graphicPlane.father = this
                @logicPlane.father = this
                @add(@logicPlane)
                @add(@graphicPlane)
                #@addToLayer(layer)
)
