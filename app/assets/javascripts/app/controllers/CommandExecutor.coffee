class CommandExecutor extends CC.controllers.Abstract
    constructor:->
        super()

    eval:(code)=>
        
        self = @
        
        S.import(["/js/coffee-script.js"], ()->
            code = CoffeeScript.compile(code)

            # Elements in these namespace are directly available in the code
            code = self.addToGlobalNamespace(code, "CC.views.draw.primitives")

            eval(code)
        )

    # Takes all the elements of the current namespace and
    # make them available to code
    addToGlobalNamespace:(code, namespaceString)->

        #debugger

        namespace = eval(namespaceString)

        for c,obj of namespace
            r = new RegExp(c, "g")
            code = code.replace(r, namespaceString + "." + c)
        return code

# this object is a singleton
CC.controllers.CommandExecutor = new CommandExecutor()
