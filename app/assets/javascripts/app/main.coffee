###
# Main module, define namespaces and some useful funcs #
###

# Namespace
window.CC = {}

S.config = {
    path: "/assets/app/libs/solid/framework/", # The path of the init file of solid
    requireConfig:{ # Standard require configuration passed to the internal requirejs instance
        baseUrl: "/assets/app"
    }
}

# Startup dell'applicazione
$(window).load ->
    S.import(
        ["controllers/Main","utils/functions"], 
        (Main)->
            console.log("Startup")
    )

