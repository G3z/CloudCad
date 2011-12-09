
define(
    "views/gui/TopBar",
    ["views/Abstract", "views/gui/Window", "controllers/CommandExecutor"],
    (Abstract, Window)->
        class TopBar extends Abstract

            ###
            This class holds events from the TopBar, *this CC.views.gui.TopBar it's NOT a class it's an instance* that's
            because we need just one TopBar and we don't need to instantiate new TopBars
            ###

            @get: (args) -> # Must be a static method
                _instance ?= new _TopBar args

            help:->
                alert("HELLO")

            runScript:->
                
                require(["/js/codemirror2/lib/codemirror.js"], ()->
                    # devo spezzarlo perchè questo script richiede che codemirror sia già stato elaborato
                    require(['/js/codemirror2/mode/coffeescript/coffeescript.js'], ()->
                
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
                            CC.controllers.CommandExecutor.eval(text)
                        )
                    )
                )

        # Store the instance
        CC.views.gui.TopBar = new TopBar()

)
