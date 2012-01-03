#
#   Abstract class for every controller
#

S.export(
    "controllers/Abstract",
    ()->
        class CC.controllers.Abstract extends Spine.Controller

            constructor: (view) ->
                super()
                @view = view

            getView:->
                return @view;
)

    