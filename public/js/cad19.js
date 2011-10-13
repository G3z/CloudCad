(function() {
  var Cad19, cadView;
  Cad19 = (function() {
    var camera, geometry, material, mesh, renderer, scene;
    camera = null;
    scene = null;
    renderer = null;
    geometry = null;
    material = null;
    mesh = null;
    function Cad19(glOrNot) {
      this.glOrNot = glOrNot;
      camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 10000);
      camera.position.z = 1000;
      scene = new THREE.Scene();
      geometry = new THREE.CubeGeometry(200, 200, 200);
      material = new THREE.MeshBasicMaterial({
        color: 0xff0000,
        wireframe: false
      });
      mesh = new THREE.Mesh(geometry, material);
      scene.add(mesh);
      if (glOrNot) {
        renderer = new THREE.WebGLRenderer();
      } else {
        renderer = new THREE.WebCanvasRenderer();
      }
      renderer.setSize(window.innerWidth, window.innerHeight);
      document.body.appendChild(renderer.domElement);
    }
    Cad19.prototype.animate = function() {
      requestAnimFrame(cadView.animate);
      return cadView.render();
    };
    Cad19.prototype.render = function() {
      mesh.rotation.x += 0.01;
      mesh.rotation.y += 0.02;
      return renderer.render(scene, camera);
    };
    return Cad19;
  })();
  cadView = new Cad19(true);
  cadView.animate();
}).call(this);
