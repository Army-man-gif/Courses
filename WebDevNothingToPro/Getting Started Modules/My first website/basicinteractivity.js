const listItems = document.querySelectorAll("li");

function toggleDone(e) {
  e.target.classList.toggle("done");
}

listItems.forEach((item) => {
  item.addEventListener("click", toggleDone);
});