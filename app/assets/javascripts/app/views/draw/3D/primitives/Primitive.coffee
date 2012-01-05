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
                        @layer = @class.toLowerCase()
                        @layer = @layer.replace("3d","s")
                        
                @id = Math.guid()
            
            addToLayer:()=>
                if window.stage3d.layers[@layer]?
                    window.stage3d.layers[@layer].push(this)
                else
                    window.stage3d.layers[@layer]=[this]
)