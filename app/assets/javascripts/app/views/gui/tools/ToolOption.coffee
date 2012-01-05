S.export(
    "views/gui/tools/ToolOption",
    ()->

        class ToolOption extends Backbone.Model

            constructor:(options)->
                super(options)
                @labels = {}

            setLabel: (property, label)=>
                @labels[property] = label

            getLabel: (property)=>
                @labels[property]
)
