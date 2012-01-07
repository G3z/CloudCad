S.export(
    "functions"
    ()->
        # Generatore di GUID
        Math.guid=->
            s = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
            f=(c)->
                r = Math.random()*16|0
                if (c=="x")
                    v=r
                else
                    v = (r&0x3|0x8)
                return v.toString(16)
            return s.replace(/[xy]/g,f).toUpperCase()
        Math.toRadian=(a)->
            return a / 180 * Math.PI
        Math.toDegree=(a)->
            return a * 180 / Math.PI
        # Funzione per il debug
        window.debug = (obj, message)->
            console.log(obj, message)

        # Funzione per la rimozione di un elemento all'interno dell'array
        Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

        THREE.Vector3::toObject=(object)->
            worldMatrix=(object,matO)->                
                if object.parent?
                    mat = new THREE.Matrix4()
                    matP = new THREE.Matrix4()
                    unless matO?
                        matO = new THREE.Matrix4()
                        mat.multiply(matO.getInverse(object.matrix), matP.getInverse(object.parent.matrix))
                    else
                        mat.multiply(matO, matP.getInverse(object.parent.matrix))

                    unless object.parent instanceof THREE.Scene
                        return worldMatrix(object.parent,mat)
                    else
                        return mat
                else
                    mat = new THREE.Matrix4()
                    return mat.getInverse(object.matrix)

            if object.matrix?
                object.updateMatrix()
                mat = worldMatrix(object)
                return mat.multiplyVector3(@clone())
        THREE.Vector3::fromObject=(object)->
            if object.matrix?
                object.updateMatrix()
                return object.matrixWorld.multiplyVector3(@clone())
)