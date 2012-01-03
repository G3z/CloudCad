
S.export(
    "models/Project",
    ["models/Abstract"]
    (AbstractModel)->
    
        class Project extends AbstractModel

        ###
        This class holds all the information about the current project and store it on the server
        ###

        @configure "Project", "commands"
        constructor:->
            super()

            #TODO: start the sync time
)
