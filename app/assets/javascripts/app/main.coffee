###
# Main module, define namespaces and some useful funcs #
###

# Namespaces
window.CC = {}
window.CC = {}
window.CC.views = {}
window.CC.views.draw = {} # Classes used by the draw area
window.CC.views.gui = {} # Classes that defined GUI widgets
window.CC.controllers = {}
window.CC.models = {}

window.debug = (obj, message)->
    console.log(obj, message)

$(document).ready ->
    mainController = new CC.controllers.Main()