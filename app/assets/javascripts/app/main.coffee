###
# Main module, define namespaces and some useful funcs #
###

# Namespaces
window.CC = {}
window.CC.views = {}
window.CC.views.draw = {} # Classes used by the draw area
window.CC.views.draw.primitives = {}
window.CC.views.draw.tools = {}
window.CC.views.gui = {} # Classes that defined GUI widgets
window.CC.views.gui.tools = {} # Classes that defined GUI widgets

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

