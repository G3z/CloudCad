define(
    "views/draw/3D/primitives/Plane3D"
    ["views/draw/3D/primitives/Primitive"],
    (Primitive)->
        class CC.views.draw.primitives.Plane3D extends Primitive
            constructor:(attr)->
                super()

                defaults = {
                    position : new THREE.Vector3()
                    rotation : new THREE.Vector3()
                    color : 0xaa0000
                    layer:"scene"
                }

                unless attr?
                    @position = defaults.position
                    @rotation = defaults.rotation
                    @color = defaults.color
                    layer = defaults.layer
                else
                    if attr.position? then @position = attr.position else @position = defaults.position
                    if attr.rotation? then @rotation = attr.rotation else @rotation = defaults.rotation
                    if attr.color? then @color = attr.color else @color = defaults.color
                    if attr.layer? then layer = attr.layer else layer = defaults.layer
                
                @plane = new THREE.Mesh( new THREE.PlaneGeometry( 600, 400, 2, 2 ), new THREE.MeshBasicMaterial( { 
                                color: @color
                                opacity: .3
                                transparent: false
                                wireframe: true
                            }))
                @plane.father = this
                @add(@plane)
                #@addToLayer(layer)
                    
)