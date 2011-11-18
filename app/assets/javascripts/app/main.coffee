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
window.CC.controllers = {}
window.CC.models = {}

require.config({
    baseUrl: "/assets/app"
})

# Startup dell'applicazione
$(window).load ->
    
    require(
        ["controllers/Main"], 
        (Main)->
            CC.mainController = new Main()
    )