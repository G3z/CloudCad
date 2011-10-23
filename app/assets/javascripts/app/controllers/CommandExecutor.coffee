
class CommandExecutor extends CC.controllers.Abstract
    constructor:->
        super()

    eval:(code)=>
        code = CoffeeScript.compile(code)
        eval(code)

# this object is a singleton
CC.controllers.CommandExecutor = new CommandExecutor()
