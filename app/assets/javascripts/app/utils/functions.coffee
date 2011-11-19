define(
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

        # Funzione per il debug
        window.debug = (obj, message)->
            console.log(obj, message)

        # Funzione per la rimozione di un elemento all'interno dell'array
        Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
)