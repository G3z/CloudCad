
define(
    "views/Abstract"
    ()->
        class CC.views.Abstract extends Spine.Controller
            
            @extend(Spine.Events)
            
            ###
            This class is the parent class for every view class
            ###

            @parent # the parent DOM element
)