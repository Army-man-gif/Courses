const Image = document.querySelector("img");

function func(e){
    const img  = e.target;
    const SR = img.getAttribute("src");
    const path1 = "images/NF.jpeg";
    const path2 ="images/stormfly.png";
    if(SR === path1){
        img.setAttribute("src",path2);
    }
    else{
        img.setAttribute("src",path1);
    }
}

const listen = Image.addEventListener("click",func);