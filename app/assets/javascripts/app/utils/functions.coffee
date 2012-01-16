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
            if object.matrix?
                object.updateMatrix()
                object.updateMatrixWorld()
                mat = new THREE.Matrix4().getInverse(object.matrixWorld)
                return mat.multiplyVector3(@clone())
                
        THREE.Vector3::fromObject=(object)->
            if object.matrix?
                object.updateMatrix()
                return object.matrixWorld.multiplyVector3(@clone())
        
        THREE.Vector3::toString=()->
            return "x:" + @x + " y:" + @y + " z:" + @z
)