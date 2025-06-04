const Image = document.querySelector("img");

function func(e){
    const SR = e.getAttribute("src");
    ,if(SR === "C:\Users\khait\Downloads\Courses\WebDevNothingToPro\Getting Started Modules\My first website\images\NF.jpeg"){
        SR.setAttribute("C:\Users\khait\Downloads\Courses\WebDevNothingToPro\Getting Started Modules\My first website\images\stormfly.png");
    }
    else{
        SR.setAttribute("C:\Users\khait\Downloads\Courses\WebDevNothingToPro\Getting Started Modules\My first website\images\NF.jpeg");
    }
}

const listen = Image.addEventListener("click",func);