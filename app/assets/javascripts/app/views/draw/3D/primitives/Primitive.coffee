S.export(
    "views/draw/3D/primitives/Primitive"
    ()->
        class Primitive extends THREE.Object3D
            @id
            @name
            constructor:()->
                super()
                if @constructor.toString?
                    arr = @constructor.toString().match(/function\s*(\w+)/)
                    if arr? and  arr.length == 2
                        @class = arr[1]
                @id = Math.guid()
            
            addToLayer:(layer)=>
                window.stage3d[layer].add(this)
)