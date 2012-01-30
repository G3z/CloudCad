define(
    "models/Actions"
    ["models/Action"]
    (Action)->

        class Actions extends Backbone.Collection

            model: Action
        
        # Singleton 
        new Actions()
)
