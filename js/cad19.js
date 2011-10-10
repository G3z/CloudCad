 (function() {
  var Cad19, cad;
  Cad19 = (function() {
    var cubeVertexColorBuffer, cubeVertexPositionBuffer, gl, lastTime, mvMatrix, mvMatrixStack, pMatrix, pyramidVertexColorBuffer, pyramidVertexPositionBuffer, rCube, rPyramid, shaderProgram;
    pyramidVertexPositionBuffer = "";
    cubeVertexPositionBuffer = "";
    gl = "";
    shaderProgram = "";
    pyramidVertexColorBuffer = "";
    cubeVertexColorBuffer = "";
    mvMatrix = mat4.create();
    mvMatrixStack = [];
    pMatrix = mat4.create();
    rPyramid = 0;
    rCube = 0;
    lastTime = 0;
    Cad19.prototype.degToRad = function(degrees) {
      return degrees * Math.PI / 180;
    };
    Cad19.prototype.initGL = function(canvas) {
      /*
      			Inizializzo il sistema WebGL sul canvas specificato
      		*/      try {
        gl = canvas.getContext("experimental-webgl");
        gl.viewportWidth = canvas.width;
        gl.viewportHeight = canvas.height;
      } catch (e) {

      }
      if (!(gl != null)) {
        alert("Could not initialise WebGL, sorry :-(");
      }
    };
    Cad19.prototype.initShaders = function() {
      /*
      			Inizializzo gli shaders
      		*/
      var fragmentShader, vertexShader;
      fragmentShader = this.getShader(gl, "shader-fs");
      vertexShader = this.getShader(gl, "shader-vs");
      shaderProgram = gl.createProgram();
      gl.attachShader(shaderProgram, vertexShader);
      gl.attachShader(shaderProgram, fragmentShader);
      gl.linkProgram(shaderProgram);
      if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS)) {
        alert("Could not initialise shaders");
      }
      gl.useProgram(shaderProgram);
      shaderProgram.vertexPositionAttribute = gl.getAttribLocation(shaderProgram, "aVertexPosition");
      gl.enableVertexAttribArray(shaderProgram.vertexPositionAttribute);
      shaderProgram.vertexColorAttribute = gl.getAttribLocation(shaderProgram, "aVertexColor");
      gl.enableVertexAttribArray(shaderProgram.vertexColorAttribute);
      shaderProgram.pMatrixUniform = gl.getUniformLocation(shaderProgram, "uPMatrix");
      shaderProgram.mvMatrixUniform = gl.getUniformLocation(shaderProgram, "uMVMatrix");
    };
    Cad19.prototype.getShader = function(gl, id) {
      /*
      			Carico lo shader che mi viene richiesto
      		*/
      var k, shader, shaderScript, str;
      shaderScript = document.getElementById(id);
      if (!(shaderScript != null)) {
        return null;
      }
      str = "";
      k = shaderScript.firstChild;
      while (k) {
        if (k.nodeType === 3) {
          str += k.textContent;
        }
        k = k.nextSibling;
      }
      shader = "";
      if (shaderScript.type === "x-shader/x-fragment") {
        shader = gl.createShader(gl.FRAGMENT_SHADER);
      } else if (shaderScript.type === "x-shader/x-vertex") {
        shader = gl.createShader(gl.VERTEX_SHADER);
      } else {
        return null;
      }
      gl.shaderSource(shader, str);
      gl.compileShader(shader);
      if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
        alert(gl.getShaderInfoLog(shader));
        return null;
      }
      return shader;
    };
    Cad19.prototype.setMatrixUniforms = function() {
      /*
      			?CREDO che scali le immagini riportate dallo shader alla dimenzione del canvas o qualcosa del genere?
      		*/      gl.uniformMatrix4fv(shaderProgram.pMatrixUniform, false, pMatrix);
      gl.uniformMatrix4fv(shaderProgram.mvMatrixUniform, false, mvMatrix);
    };
    Cad19.prototype.initBuffers = function() {
      /*
      			Qui vengono create le forme (triangolo e quadrato) che vengono visualizzate
      		*/
      var colors, num, squareVertexColorBuffer, squareVertexPositionBuffer, triangleVertexColorBuffer, triangleVertexPositionBuffer, vertices;
      triangleVertexPositionBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexPositionBuffer);
      vertices = [0.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, -1.0, 0.0];
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
      triangleVertexPositionBuffer.itemSize = 3;
      triangleVertexPositionBuffer.numItems = 3;
      triangleVertexColorBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, triangleVertexColorBuffer);
      colors = [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0];
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
      triangleVertexColorBuffer.itemSize = 4;
      triangleVertexColorBuffer.numItems = 3;
      squareVertexPositionBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexPositionBuffer);
      vertices = [1.0, 1.0, 0.0, -1.0, 1.0, 0.0, 1.0, -1.0, 0.0, -1.0, -1.0, 0.0];
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
      squareVertexPositionBuffer.itemSize = 3;
      squareVertexPositionBuffer.numItems = 4;
      squareVertexColorBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, squareVertexColorBuffer);
      colors = [];
      for (num = 1; num <= 4; num++) {
        colors = colors.concat([0.5, 0.5, 0.25 * num, 1.0]);
      }
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
      squareVertexColorBuffer.itemSize = 4;
      squareVertexColorBuffer.numItems = 4;
    };
    Cad19.prototype.drawScene = function() {
      /*
      			Funzione che disegna le forme sul canvas
      		*/      gl.viewport(0, 0, gl.viewportWidth, gl.viewportHeight);
      gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
      mat4.perspective(45, gl.viewportWidth / gl.viewportHeight, 0.1, 100.0, pMatrix);
      mat4.identity(mvMatrix);
      mat4.translate(mvMatrix, [-1.5, 0.0, -7.0]);
      this.mvPushMatrix();
      mat4.rotate(mvMatrix, this.degToRad(rPyramid), [0, 1, 0]);
      gl.bindBuffer(gl.ARRAY_BUFFER, pyramidVertexPositionBuffer);
      gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, pyramidVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ARRAY_BUFFER, pyramidVertexColorBuffer);
      gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, pyramidVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
      this.setMatrixUniforms();
      gl.drawArrays(gl.TRIANGLES, 0, pyramidVertexPositionBuffer.numItems);
      mvPopMatrix();
      mat4.translate(mvMatrix, [3.0, 0.0, 0.0]);
      this.mvPushMatrix();
      mat4.rotate(mvMatrix, this.degToRad(rCube), [1, 1, 1]);
      gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexPositionBuffer);
      gl.vertexAttribPointer(shaderProgram.vertexPositionAttribute, cubeVertexPositionBuffer.itemSize, gl.FLOAT, false, 0, 0);
      gl.bindBuffer(gl.ARRAY_BUFFER, cubeVertexColorBuffer);
      gl.vertexAttribPointer(shaderProgram.vertexColorAttribute, cubeVertexColorBuffer.itemSize, gl.FLOAT, false, 0, 0);
      this.setMatrixUniforms();
      gl.drawArrays(gl.TRIANGLE_STRIP, 0, cubeVertexPositionBuffer.numItems);
      this.mvPopMatrix();
    };
    Cad19.prototype.mvPushMatrix = function() {
      var copy;
      copy = mat4.create();
      mat4.set(mvMatrix, copy);
      mvMatrixStack.push(copy);
    };
    Cad19.prototype.mvPopMatrix = function() {
      if (mvMatrixStack.length === 0) {
        throw "Invalid popMatrix!";
      }
      mvMatrix = mvMatrixStack.pop();
    };
    Cad19.prototype.animate = function() {
      var elapsed, timeNow;
      timeNow = new Date().getTime();
      if (lastTime !== 0) {
        elapsed = timeNow - lastTime;
        rPyramid += (180 * elapsed) / 1000.0;
        rCube += (90 * elapsed) / 1000.0;
      }
      return lastTime = timeNow;
    };
    Cad19.prototype.tick = function() {
      requestAnimFrame(@tick);
      this.drawScene();
      this.animate();
    };
    function Cad19(canvasName) {
      var canvas;
      this.canvasName = canvasName;
      canvas = document.getElementById(this.canvasName);
      this.initGL(canvas);
      this.initShaders();
      this.initBuffers();
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      gl.enable(gl.DEPTH_TEST);
      this.tick();
      this.drawScene();
      return;
    }
    return Cad19;
  })();
  $.ready(cad = new Cad19("3dcanvas"));
}).call(this);
