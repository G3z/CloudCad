(function() {
  /*
      *-- FUNZIONI PER IL MOUSE --*
      Per chiarezza sarebbero da spostare su un altro file
  */
  var Cad19, Cad19_Mouse, Cad19_Mouse_Button, cadView;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  Cad19_Mouse_Button = (function() {
    function Cad19_Mouse_Button() {
      this.down = false;
      this.click = {
        start: {
          x: 0,
          y: 0
        },
        currentPos: {
          x: 0,
          y: 0
        },
        delta: {
          w: 0,
          h: 0
        },
        oldDelta: {
          w: 0,
          h: 0
        }
      };
    }
    return Cad19_Mouse_Button;
  })();
  Cad19_Mouse = (function() {
    function Cad19_Mouse() {
      this.rotationY = __bind(this.rotationY, this);
      this.rotationX = __bind(this.rotationX, this);      this.rotationScale = 0.003;
      this.btn1 = new Cad19_Mouse_Button();
      this.btn2 = new Cad19_Mouse_Button();
      this.btn2 = new Cad19_Mouse_Button();
      $(document).mousedown(__bind(function(event) {
        return this.mouseDown({
          x: event.clientX,
          y: event.clientY
        }, event.which);
      }, this));
      $(document).mousemove(__bind(function(event) {
        return this.mouseDragged({
          x: event.clientX,
          y: event.clientY
        }, event.which);
      }, this));
      $(document).mouseup(__bind(function(event) {
        return this.mouseUp({
          x: event.clientX,
          y: event.clientY
        }, event.which);
      }, this));
    }
    Cad19_Mouse.prototype.mouseDown = function(point, button) {
      if (button === 1) {
        this.btn1.down = true;
        this.btn1.click.start = point;
        this.btn1.click.currentPos = point;
      }
      if (button === 2) {
        this.btn2.down = true;
        this.btn2.click.start = point;
        this.btn2.click.currentPos = point;
      }
      if (button === 3) {
        this.btn3.down = true;
        this.btn3.click.start = point;
        return this.btn3.click.currentPos = point;
      }
    };
    Cad19_Mouse.prototype.mouseDragged = function(point, button) {
      if (button === 1 && this.btn1.down) {
        this.btn1.click.currentPos = point;
        this.btn1.click.delta = {
          w: this.btn1.click.oldDelta.w + point.x - this.btn1.click.start.x,
          h: this.btn1.click.oldDelta.h + point.y - this.btn1.click.start.y
        };
      }
      if (button === 2 && this.btn2.down) {
        this.btn2.click.currentPos = point;
        this.btn2.click.delta = {
          w: this.btn2.click.oldDelta.w + point.x - this.btn2.click.start.x,
          h: this.btn2.click.oldDelta.h + point.y - this.btn2.click.start.y
        };
      }
      if (button === 3 && this.btn3.down) {
        this.btn3.click.currentPos = point;
        return this.btn3.click.delta = {
          w: this.btn3.click.oldDelta.w + point.x - this.btn3.click.start.x,
          h: this.btn3.click.oldDelta.h + point.y - this.btn3.click.start.y
        };
      }
    };
    Cad19_Mouse.prototype.mouseUp = function(point, button) {
      if (button === 1 && this.btn1.down) {
        this.btn1.down = false;
        this.btn1.click.oldDelta = this.btn1.click.delta;
      }
      if (button === 2 && this.btn2.down) {
        this.btn2.down = false;
        this.btn3.click.oldDelta = this.btn3.click.delta;
      }
      if (button === 3 && this.btn3.down) {
        this.btn3.down = false;
        return this.btn3.click.oldDelta = this.btn3.click.delta;
      }
    };
    Cad19_Mouse.prototype.rotationX = function() {
      return this.btn1.click.delta.h * this.rotationScale;
    };
    Cad19_Mouse.prototype.rotationY = function() {
      return this.btn1.click.delta.w * this.rotationScale;
    };
    return Cad19_Mouse;
  })();
  Cad19 = (function() {
    Cad19.camera;
    Cad19.scene;
    Cad19.renderer;
    Cad19.geometry;
    Cad19.material;
    Cad19.mesh;
    Cad19.light;
    Cad19.ambientLight;
    Cad19.origin;
    function Cad19(glOrNot) {
      this.glOrNot = glOrNot;
      this.render = __bind(this.render, this);
      this.animate = __bind(this.animate, this);
      this.mouse = new Cad19_Mouse();
      this.camera = new THREE.PerspectiveCamera(35, (window.innerWidth - 50) / (window.innerHeight - 50), 1, 10000);
      this.camera.position.z = 1000;
      this.scene = new THREE.Scene();
      this.geometry = new THREE.CubeGeometry(200, 200, 200);
      this.material = new THREE.MeshLambertMaterial({
        color: 0x8866ff,
        wireframe: false
      });
      this.mesh = new THREE.Mesh(this.geometry, this.material);
      this.scene.add(this.mesh);
      this.light = new THREE.PointLight(0xFFFF00, .4);
      this.light.position.set(400, 300, 400);
      this.scene.add(this.light);
      this.ambientLight = new THREE.AmbientLight(0x888888);
      this.scene.add(this.ambientLight);
      if (glOrNot === "canvas") {
        this.renderer = new THREE.CanvasRenderer();
      } else if (glOrNot === "svg") {
        this.renderer = new THREE.SVGRenderer();
      } else {
        this.renderer = new THREE.WebGLRenderer({
          antialias: true,
          canvas: document.createElement('canvas'),
          clearColor: 0x111188,
          clearAlpha: 0.2,
          maxLights: 4,
          stencil: true,
          preserveDrawingBuffer: true
        });
      }
      this.renderer.setSize(window.innerWidth - 50, window.innerHeight - 50);
      document.body.appendChild(this.renderer.domElement);
    }
    Cad19.prototype.animate = function() {
      requestAnimFrame(this.animate);
      return this.render();
    };
    Cad19.prototype.render = function() {
      this.mesh.rotation.x = this.mouse.rotationX();
      this.mesh.rotation.y = this.mouse.rotationY();
      return this.renderer.render(this.scene, this.camera);
    };
    return Cad19;
  })();
  cadView = new Cad19();
  cadView.animate();
}).call(this);
