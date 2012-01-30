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
            
            promoteTo:(obj)=>
                walk = (start,target)=>
                    if start.parent?
                        #console.log "Object Promotion: processing " + start.parent.class
                        if start.parent.id?
                            if start.parent.id != target
                                @position.addSelf(start.parent.position)
                                @rotation.addSelf(start.parent.rotation)
                                return walk(start.parent,target)
                            else
                                @rotation.addSelf(start.parent.position)
                                @rotation.addSelf(start.parent.rotation)
                                #console.log "Object Promotion:Done"
                                return
                        else
                            #console.log "Object Promotion:No ID"
                            return
                    else
                        #console.log "Object Promotion:No Parent"
                        return
                target = obj.id
                walk(this,target)
 
                obj.parent.add(this)

            isChildOf:(object)=>
                walk=(parent,id)=>
                    if parent.id == id
                        return true
                    else
                        if parent.parent?.id?
                            return walk(parent.parent,id)
                        else
                            return false
                        
                return walk(@parent,object.id)

            load:(object)=>
                throw "Please implement me!"

            store:(object)=>
                throw "Please implement me!"
)
