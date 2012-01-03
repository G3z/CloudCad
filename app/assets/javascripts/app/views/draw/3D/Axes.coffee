S.export(
    "views/draw/3D/Axes"
    ()->
        class Axes extends THREE.Object3D
            constructor:(@stage3d)->
                lineGeometry = new THREE.Geometry()
                lineGeometry.vertices.push( new THREE.Vertex() )
                lineGeometry.vertices.push( new THREE.Vertex( new THREE.Vector3( 0, 100, 0 ) ) )

                coneGeometry = new THREE.CylinderGeometry( 0, 5, 25, 5, 1 )

                # x

                line = new THREE.Line( lineGeometry, new THREE.LineBasicMaterial( { color : 0xff0000 } ) )
                line.rotation.z = - Math.PI / 2
                @add( line )

                cone = new THREE.Mesh( coneGeometry, new THREE.MeshBasicMaterial( { color : 0xff0000 } ) )
                cone.position.x = 100
                cone.rotation.z = - Math.PI / 2
                @add( cone )

                # y

                line = new THREE.Line( lineGeometry, new THREE.LineBasicMaterial( { color : 0x00ff00 } ) )
                @add( line )

                cone = new THREE.Mesh( coneGeometry, new THREE.MeshBasicMaterial( { color : 0x00ff00 } ) )
                cone.position.y = 100
                @add( cone )

                # z

                line = new THREE.Line( lineGeometry, new THREE.LineBasicMaterial( { color : 0x0000ff } ) )
                line.rotation.x = Math.PI / 2
                @add( line )

                cone = new THREE.Mesh( coneGeometry, new THREE.MeshBasicMaterial( { color : 0x0000ff } ) )
                cone.position.z = 100
                cone.rotation.x = Math.PI / 2
                @add( cone )
                @scale.x = @scale.y = @scale.z = 0.07

                @update()
            
            update:=>
                @position = @stage3d.camera.position.clone()

                @position.x -= 10
                @position.y -= 10
                @position.z -= 100
                
    )