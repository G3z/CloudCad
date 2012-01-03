### MouseWheel ###
# MouseWheel class is a simple class that represents the mouse wheel
# this class has no methods it just contains the coordinates to register various events
S.export(
    "views/MouseWheel",
    ()->
        class CC.views.MouseWheel
            constructor:->
                @direction = ""
                @speed = 0
)
