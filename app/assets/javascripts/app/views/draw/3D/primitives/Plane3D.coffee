S.export(
    "views/draw/3D/primitives/Plane3D"
    [
        "views/draw/3D/primitives/Primitive"
    ],
    (Primitive)->
        class CC.views.draw.primitives.Plane3D extends Primitive
            constructor:(attr)->
                super()
                @matrixAutoUpdate = true
                defaults = {
                    position : new THREE.Vector3()
                    rotation : new THREE.Vector3()
                    size:
                        w:600
                        h:400
                    color : 0xaa0000
                    layer:"scene"
                }
                unless attr?
                    @position = defaults.position
                    rotation = defaults.rotation
                    size = defaults.size
                    @color = defaults.color
                    layer = defaults.layer
                else
                    if attr.position? then @position = attr.position else @position = defaults.position
                    if attr.rotation? then rotation = attr.rotation else rotation = defaults.rotation
                    if attr.size? then size = attr.size else size = defaults.size
                    if attr.color? then @color = attr.color else @color = defaults.color
                    if attr.layer? then layer = attr.layer else layer = defaults.layer
                
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
                        new THREE.CurvePath.prototype.createGeometry([new THREE.Vector2(0,0),new THREE.Vector2(100,0)]),
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
                @mesh = new THREE.Mesh( new THREE.PlaneGeometry( size.w, size.h, 2, 2 ), new THREE.MeshBasicMaterial( { 
                                color: @color
                                opacity: 0.05
                                transparent: true
                                wireframe: false
                                blending: THREE.AdditiveAlphaBlending
                            }))
                @mesh.doubleSided=true
                @mesh.dynamic=false
                
                @updateMatrix()
                console.log @up
                @up = @matrix.multiplyVector3(@up.clone())
                @up.subSelf(@position)

                @normal = @matrix.multiplyVector3(@mesh.geometry.faces[0].normal.clone())
                @normal.subSelf(@position)
                @mesh.father = this
                @add(@mesh)
                #@addToLayer(layer)
)