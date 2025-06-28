import { useEffect } from "react";

function Alarm(){
    useEffect(() => {
        const output = document.querySelector("#output");
        const button = document.querySelector("#set-alarm");

        function setAlarm() {
            setTimeout(() => {
                output.textContent = "Wake up!";
            }, 1000);
        }

        button.addEventListener("click", setAlarm);

    },[])
    return(
        <>
            <button id="set-alarm">Set alarm</button>
            <div id="output"></div>
        </>
    )
}

export default Alarm