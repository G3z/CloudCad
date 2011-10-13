(function() {
  var Cad19, cadView;
  Cad19 = (function() {
    Cad19.camera;
    Cad19.scene;
    Cad19.renderer;
    Cad19.geometry;
    Cad19.material;
    Cad19.mesh;
    Cad19.light;
    Cad19.ambientLight;
    Cad19.mouseX;
    Cad19.mouseY;
    Cad19.mouseDown;
    Cad19.origin;
    Cad19.oldDelta;
    function Cad19(glOrNot) {
      this.glOrNot = glOrNot;
      this.mouseX = 1;
      this.mouseY = 1;
      this.mouseDown = false;
      this.origin = {
        x: window.innerWidth / 2,
        y: window.innerHeight / 2
      };
      this.oldDelta = {
        x: 0,
        y: 0
      };
      this.camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.z = 1000;
      this.scene = new THREE.Scene();
      this.geometry = new THREE.CubeGeometry(200, 200, 200);
      this.material = new THREE.MeshLambertMaterial({
        color: 0xff0000,
        wireframe: false
      });
      this.mesh = new THREE.Mesh(this.geometry, this.material);
      this.scene.add(this.mesh);
      this.light = new THREE.PointLight(0xFFFF00, .4);
      this.light.position.set(400, 300, 400);
      this.scene.add(this.light);
      this.ambientLight = new THREE.AmbientLight(0x888888);
      this.scene.add(this.ambientLight);
      if (glOrNot) {
        this.renderer = new THREE.WebGLRenderer();
      } else {
        this.renderer = new THREE.CanvasRenderer();
      }
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      /*
                  *-- FUNZIONI PER IL MOUSE --*
                  Per chiarezza sarebbero da spostare su un altro file
              */
      $(document).mousedown(function(event) {
        cadView.mouseDown = true;
        cadView.origin.x = event.clientX;
        return cadView.origin.y = event.clientY;
      });
      $(document).mousemove(function(event) {
        if (cadView.mouseDown) {
          cadView.mouseX = cadView.oldDelta.x + event.clientX - cadView.origin.x;
          return cadView.mouseY = cadView.oldDelta.y + event.clientY - cadView.origin.y;
        }
      });
      $(document).mouseup(function(event) {
        cadView.mouseDown = false;
        cadView.oldDelta.x = cadView.mouseX;
        return cadView.oldDelta.y = cadView.mouseY;
      });
      document.body.appendChild(this.renderer.domElement);
    }
    Cad19.prototype.animate = function() {
      requestAnimFrame(cadView.animate);
      return cadView.render();
    };
    Cad19.prototype.render = function() {
      this.mesh.rotation.x = this.mouseY * 0.003;
      this.mesh.rotation.y = this.mouseX * 0.003;
      return this.renderer.render(this.scene, this.camera);
    };
    return Cad19;
  })();
  cadView = new Cad19(false);
  cadView.animate();
}).call(this);
