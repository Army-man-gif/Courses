import { useEffect } from 'react';
import * as THREE from 'three';
function Three(){
    useEffect(() => {
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(
            75,
            window.innerWidth / window.innerHeight,
            0.1,
            1000,
        );
        camera.position.z = 5;
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        document.body.appendChild(renderer.domElement);



        let cube;

        const loader = new THREE.TextureLoader();

        loader.load("C:/Users/khait/Downloads/download(1).jpeg", (texture) => {

            texture.wrapS = THREE.RepeatWrapping;
            texture.wrapT = THREE.RepeatWrapping;
            texture.repeat.set(2, 2);

            const geometry = new THREE.BoxGeometry(2.4, 2.4, 2.4);
            const material = new THREE.MeshLambertMaterial({ map: texture });
            cube = new THREE.Mesh(geometry, material);
            scene.add(cube);

            draw();
        
        });
    },[]);

    return (
        <>
        </>
    )
}


export default Three
