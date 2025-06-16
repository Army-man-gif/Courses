  const form = document.getElementById("exampleForm");
  const output = document.getElementById("formOutput");

  form.addEventListener("submit", function (e) {
    e.preventDefault(); // Stop form from actually submitting

    const formData = new FormData(form);
    let summary = "Form submitted with:\n";

    for (const [name, value] of formData.entries()) {
      summary += `${name}: ${value}\n`;
    }

    output.textContent = summary;
  });