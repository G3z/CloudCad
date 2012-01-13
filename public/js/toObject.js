THREE.Vector3.prototype.toObject = function(object) {
    var mat, worldMatrix;
    worldMatrix = function(object, matO) {
        var mat, matP;
        if (object.parent != null) {
            mat = new THREE.Matrix4();
            matP = new THREE.Matrix4();
            if (matO == null) {
                matO = new THREE.Matrix4();
                mat.multiply(matO.getInverse(object.matrix), matP.getInverse(object.parent.matrix));
            } else {
                mat.multiply(matO, matP.getInverse(object.parent.matrix));
            }
            if (!(object.parent instanceof THREE.Scene)) {
                return worldMatrix(object.parent, mat);
            } else {
                return mat;
            }
        } else {
            mat = new THREE.Matrix4();
            return mat.getInverse(object.matrix);
        }
    };
    if (object.matrix != null) {
        object.updateMatrix();
        mat = worldMatrix(object);
        return mat.multiplyVector3(this.clone());
    }
};
THREE.Vector3.prototype.toObject2 = function(object) {
    if (object.matrix != null) {
        object.updateMatrix();
        var mat = new THREE.Matrix4().getInverse(object.matrixWorld);
        return mat.multiplyVector3(this.clone());
    }
};
// set the scene size
var WIDTH = 400,
    HEIGHT = 300;

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
var mat1 = new THREE.MeshLambertMaterial({
    color: 0xCC0000
});

var mat2 = new THREE.MeshLambertMaterial({
    color: 0x00CC00
});

var mat3 = new THREE.MeshLambertMaterial({
    color: 0x0000CC
});

var point1 = new THREE.MeshLambertMaterial({
    color: 0xCC00CC
});

var point2 = new THREE.MeshLambertMaterial({
    color: 0xCCCC00
});

var point3 = new THREE.MeshLambertMaterial({
    color: 0x000000
});
// set up the sphere vars
var radius = 3,
    segments = 8,
    rings = 8;

// create a new mesh with sphere geometry -
// we will cover the sphereMaterial next!
var point1 = new THREE.Mesh(
new THREE.SphereGeometry(radius, segments, rings), point1);
point1.translateZ(1);

var point2 = new THREE.Mesh(
new THREE.SphereGeometry(radius, segments, rings), point2);
point2.translateZ(1);


var point3 = new THREE.Mesh(
new THREE.SphereGeometry(radius, segments, rings), point3);
scene.add(point3);

// create a point light
var pointLight = new THREE.PointLight(0xFFFFFF);

// set its position
pointLight.position.x = 10;
pointLight.position.y = 50;
pointLight.position.z = 130;

// add to the scene
scene.add(pointLight);
scene.add(camera);
var plane =new THREE.Mesh( new THREE.PlaneGeometry( 400, 400, 40, 40 ), new THREE.MeshBasicMaterial( { color: 0x000000, opacity: 0.25, transparent: false, wireframe: true } ) )
scene.add(plane);
//custom code

var cube = new THREE.Mesh(
new THREE.CubeGeometry(50, 50, 1), mat1);
var rot = new THREE.Vector3(0, 0, 0);
cube.rotation = rot;
scene.add(cube);
cube.position=new THREE.Vector3(-50, 25, 0);

var cube2 = new THREE.Mesh(
new THREE.CubeGeometry(50, 50, 1), mat2);
var rot = new THREE.Vector3(0, 0, 0);
cube2.rotation = rot;
cube2.translateX(50);
cube.add(cube2);

var cube3 = new THREE.Mesh(
new THREE.CubeGeometry(50, 50, 1), mat3);
var rot = new THREE.Vector3(0, 0, 0);
cube3.rotation = rot;
cube3.translateX(50);
cube2.add(cube3);


var pointPos = new THREE.Vector3(50,50,1);
var pos1 = pointPos.toObject(cube3);
var pos2 = pointPos.toObject2(cube3);

point1.position.copy(pos1); //purple
point2.position.copy(pos2); //yellow

cube3.add(point1);
cube3.add(point2);
// draw!
renderer.render(scene, camera);