
function three(){
    return (
        <>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r79/three.min.js"></script>
            <script>
                const scene = new THREE.Scene();
                const camera = new THREE.PerspectiveCamera(
                    75,
                    window.innerWidth / window.innerHeight,
                    0.1,
                    1000,
                );
                camera.position.z = 5;
            </script>
        </>
    )
}


export default three
