class Cad19
    triangleVertexPositionBuffer = ""
    squareVertexPositionBuffer = ""
    gl = ""
    shaderProgram=""
    triangleVertexColorBuffer=""
    squareVertexColorBuffer=""
    mvMatrix = mat4.create()
    mvMatrixStack = []
    pMatrix = mat4.create()
    rTri = 0
    rSquare = 0
    lastTime = 0

    degToRad : (degrees)->
        return degrees * Math.PI / 180

    initGL : (canvas)->
        ###
        Inizializzo il sistema WebGL sul canvas specificato
        ###
        try
            gl = canvas.getContext("experimental-webgl");
            gl.viewportWidth = canvas.width;
            gl.viewportHeight = canvas.height;
        catch e

            alert("Could not initialise WebGL, sorry :-(") if not gl?
        return


    initShaders : ->
        ###
        Inizializzo gli shaders
        ###
        fragmentShader = @getShader(gl, "shader-fs")
        vertexShader = @getShader(gl, "shader-vs")

        shaderProgram = gl.createProgram()
        gl.attachShader(shaderProgram, vertexShader)
        gl.attachShader(shaderProgram, fragmentShader)
        gl.linkProgram(shaderProgram)

        alert("Could not initialise shaders") if not gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)

        gl.useProgram(shaderProgram)

        shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition")
        gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute)

        shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram,"aVertexColor")
        gl.enableVertexAttribArray(shaderProgram.vertexColorAttribute)

        shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix")
        shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix")
        return

    getShader:(gl, id) ->
        ###
        Carico lo shader che mi viene richiesto
        ###
        shaderScript = document.getElementById(id);
        return null if !shaderScript?
        str = ""
        k = shaderScript.firstChild
        while k
            str += k.textContent if k.nodeType == 3
            k = k.nextSibling

        shader=""
        if (shaderScript.type == "x-shader/x-fragment")
            shader = gl.createShader(gl.FRAGMENT_SHADER)
        else if (shaderScript.type == "x-shader/x-vertex")
            shader = gl.createShader(gl.VERTEX_SHADER)
        else
            return null

        gl.shaderSource(shader, str)
        gl.compileShader(shader)

        if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS))
            alert(gl.getShaderInfoLog(shader));
            return null

        return shader

    setMatrixUniforms: ->
        ###
        ?CREDO che scali le immagini riportate dallo shader alla dimenzione del canvas o qualcosa del genere?
        ###
        gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix)
        gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix)
        return

    initBuffers : ->
        ###
        Qui vengono create le forme (triangolo e quadrato) che vengono visualizzate
        ###
        triangleVertexPositionBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer)
        vertices = [
            0.0,  1.0,  0.0,
            -1.0, -1.0,  0.0,
             1.0, -1.0,  0.0
        ]
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)
        triangleVertexPositionBuffer.itemSize = 3
        triangleVertexPositionBuffer.numItems = 3

        triangleVertexColorBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexColorBuffer)
        colors = [
            1.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0
        ]
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW)
        triangleVertexColorBuffer.itemSize = 4
        triangleVertexColorBuffer.numItems = 3

        squareVertexPositionBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer)
        vertices = [
            1.0,  1.0,  0.0,
            -1.0,  1.0,  0.0,
             1.0, -1.0,  0.0,
            -1.0, -1.0,  0.0
        ]
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW)
        squareVertexPositionBuffer.itemSize = 3
        squareVertexPositionBuffer.numItems = 4

        squareVertexColorBuffer = gl.createBuffer()
        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer)
        colors = []

        colors = colors.concat([0.5, 0.5, 0.25*num, 1.0]) for num in [1..4]

        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW)
        squareVertexColorBuffer.itemSize = 4
        squareVertexColorBuffer.numItems = 4

        return

    drawScene : ->
        ###
        Funzione che disegna le forme sul canvas
        ###
        gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight)
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
        mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix) #prospettiva
        mat4.identity(mvMatrix);

        #triangolo
        mat4.translate(mvMatrix, [-1.5, 0.0, -7.0])

        #rotazione del triangolo
        @mvPushMatrix()
        mat4.rotate(mvMatrix, @degToRad(rTri), [0, 1, 0])

        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer)
        gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, triangleVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0)

        #colori del triangolo
        gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexColorBuffer)
        gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, triangleVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0)

        @setMatrixUniforms()
        gl.drawArrays(gl.TRIANGLES, 0, triangleVertexPositionBuffer.numItems)
        @mvPopMatrix()

        #quadrato
        mat4.translate(mvMatrix, [3.0, 0.0, 0.0])

        #rotazione del quadrato
        @mvPushMatrix()
        mat4.rotate(mvMatrix, @degToRad(rSquare), [0, 0, 1])

        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer)
        gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, squareVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0)

        gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer)
        gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, squareVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0)

        @setMatrixUniforms()
        gl.drawArrays(gl.TRIANGLE_STRIP, 0, squareVertexPositionBuffer.numItems)
        @mvPopMatrix()
        return

    mvPushMatrix : ->
        copy = mat4.create()
        mat4.set(mvMatrix, copy)
        mvMatrixStack.push(copy)
        return

    mvPopMatrix : ->
        throw "Invalid popMatrix!" if mvMatrixStack.length == 0
        mvMatrix = mvMatrixStack.pop()
        return

    animate : ->
        timeNow = new Date().getTime()
        if (lastTime != 0)
            elapsed = timeNow - lastTime
            rTri += (180 * elapsed) / 1000.0
            rSquare += (90 * elapsed) / 1000.0
        lastTime = timeNow

    tick : ->
        window.cad.drawScene()
        window.cad.animate()
        requestAnimFrame(window.cad.tick)
        return

    constructor :(@canvasName) ->
        console.log("Inizializzo il sistema WebGL")
        canvas = document.getElementById(@canvasName)
        @initGL(canvas)
        @initShaders()
        @initBuffers()

        gl.clearColor(0.0, 0.0, 0.0, 1.0)
        gl.enable(gl.DEPTH_TEST)
        requestAnimFrame(@tick)

        return

 $.ready( window.cad = new Cad19 "3dcanvas")
