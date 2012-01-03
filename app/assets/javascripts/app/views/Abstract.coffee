
S.export(
    "views/Abstract"
    ["solid.widgets.AbstractWidget"]
    (AbstractWidget)->
        class CC.views.Abstract extends AbstractWidget
            
            @extend(Spine.Events)
            
            ###
            This class is the parent class for every view class
            ###

            @parent # the parent DOM element
)