#
#   Abstract class for every controller
#

S.export(
    "controllers/Abstract",
    ["solid.widgets.AbstractWidget"]
    (AbstractWidget)->
        class Abstract extends AbstractWidget

            constructor: (options) ->
                super(options)

            getView:->
                return @view
)
