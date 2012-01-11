// set the scene size
var WIDTH = window.innerWidth-50, 
    HEIGHT = window.innerHeight-50;

// set some camera attributes
var VIEW_ANGLE = 45,
    ASPECT = WIDTH / HEIGHT,
    NEAR = 0.1,
    FAR = 10000;

// get the DOM element to attach to
// - assume we've got jQuery to hand
var $container = $('#3d');

// create a WebGL renderer, camera
// and a scene
var renderer = new THREE.WebGLRenderer();
var camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
var scene = new THREE.Scene();

// the camera starts at 0,0,0 so pull it back
camera.position.z = 300;

// start the renderer
renderer.setSize(WIDTH, HEIGHT);

// attach the render-supplied DOM element
$container.append(renderer.domElement);

// create the sphere's material
var sphereMaterial = new THREE.MeshLambertMaterial({
    color: 0xCC0000
});

var cubeMaterial = new THREE.MeshLambertMaterial({
    color: 0x0000CC
});

// set up the sphere vars
var radius = 50,
    segments = 16,
    rings = 16;

// create a new mesh with sphere geometry -
// we will cover the sphereMaterial next!
var sphere = new THREE.Mesh(
new THREE.SphereGeometry(radius, segments, rings), sphereMaterial);

// add the sphere to the scene
scene.add(sphere);
sphere.translateX(-20);
// create a point light
var pointLight = new THREE.PointLight(0xFFFFFF);

// set its position
pointLight.position.x = 10;
pointLight.position.y = 50;
pointLight.position.z = 130;

// add to the scene
scene.add(pointLight);
scene.add(camera);

var cube = new THREE.Mesh(
new THREE.CubeGeometry(20, -100, 20), cubeMaterial);
cube.flipSided=true;
scene.add(cube);
var pos = new THREE.Vector3(0, 30, 30);


var rot = new THREE.Vector3(0, 0, -1.5707963267948966);
//var rot = new THREE.Vector3(0,0,0);
cube.position = pos;
cube.rotation = rot;
cube.translateX(-20);
/*
var mat = new THREE.Matrix4();
mat.setRotationFromEuler(rot);
var matI = new THREE.Matrix4();
matI.getInverse(mat);
matI.multiplyVector3(cube.position);
*/
var cubeCSG = THREE.CSG.toCSG(cube);
var sphereCSG = THREE.CSG.toCSG(sphere);
var geometry = THREE.CSG.fromCSG(sphereCSG.subtract(cubeCSG));
var mesh = new THREE.Mesh(geometry, sphereMaterial);
scene.add(mesh);
mesh.translateX(120);
// draw!
renderer.render(scene, camera);