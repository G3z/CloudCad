
S.export(
    "views/gui/TopBar",
    ["views/Abstract", "views/gui/Window", "controllers/CommandExecutor"],
    (Abstract, Window, CommandExecutor)->
        class TopBar extends Abstract

            constructor:->
                super()
                $("#top_bar_runscript").bind("click", @runScript)
                $("#top_bar_help").bind("click", @help)

            @get: (args) -> # Must be a static method
                _instance ?= new _TopBar args
        

            help:->
                alert("HELLO")

            runScript:->
                
                S.import(["/js/codemirror2/lib/codemirror.js"], ()->
                    # devo spezzarlo perchè questo script richiede che codemirror sia già stato elaborato
                    S.import(['/js/codemirror2/mode/coffeescript/coffeescript.js'], ()->
                
                        id = new Date().getTime()
                        html = "<div class='codeeditor' id='codeeditor_" + id + "'>"
                        html += "<textarea id='textarea_" + id + "'></textarea>"
                        html += "<br />"
                        html += "<input type='Submit' class='btn primary' value='Run' />"
                        html += "</div>"

                        win = new Window(html)

                        editor = CodeMirror.fromTextArea(
                            $('#textarea_' + id).get(0),{
                                theme: "cobalt"
                            })

                        $('#codeeditor_' + id + " input").bind('click', (evt)=>
                            text = editor.getValue()
                            CommandExecutor.eval(text)
                        )
                    )
                )

        # Store the instance
        new TopBar()

)
