


function Canvas(){
    const canvas = document.querySelector("canvas");
    const ctx = canvas.getContext("2d");

    const width = (canvas.width = window.innerWidth);
    const height = (canvas.height = window.innerHeight);

    return(
        <>
            <h1>
                Canvas
            </h1>
            <canvas>

            </canvas>
        </>
    );
}