
S.export(
    "views/Abstract"
    ()->
        class CC.views.Abstract extends Backbone.View
            
            @extend(Spine.Events)
            
            ###
            This class is the parent class for every view class
            ###

            @parent # the parent DOM element
)