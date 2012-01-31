define(
    "models/Actions"
    ["models/Action"]
    (Action)->

        class Actions extends Backbone.Collection

            model: Action
            url: "/project"
        # Singleton 
        new Actions()
)
