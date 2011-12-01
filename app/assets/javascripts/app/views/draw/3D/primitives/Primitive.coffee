define(
    "views/draw/3D/primitives/Primitive"
    ()->
        class CC.views.draw.primitives.Primitive extends THREE.Object3D
            @id
            @name
            constructor:()->
                super()
                @id = Math.guid()
            
            addToLayer:(layer)=>
                window.stage3d[layer].add(this)
)