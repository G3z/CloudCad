
S.export(
    "views/Abstract"
    ["solid.widgets.AbstractWidget"]
    (AbstractWidget)->
        class Abstract extends AbstractWidget
            
            ###
            This class is the parent class for every view class
            ###

            @parent # the parent DOM element
)