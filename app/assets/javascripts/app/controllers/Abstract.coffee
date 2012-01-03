#
#   Abstract class for every controller
#

S.export(
    "controllers/Abstract",
    ()->
        class Abstract

            constructor: (view) ->
                @view = view

            getView:->
                return @view
)