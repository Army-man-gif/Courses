const fetchPromise = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json",
);

fetchPromise.then((response) => {
  console.log(`Received response: ${response.status}`);
});

console.log("Started request…");

const fetchPromise2 = fetch(
  "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json",
);

fetchPromise2
  .then((response) => {
      console.log("Trying Promise individual thens: ");
    return response.json();
  })
  .then((data) => {
    console.log("Trying Promise individual thens: ");
    console.log(data[0].name);
  })
  .catch((error) => {
    console.log("Trying Promise individual thens: ");
    console.error(`Could not get products: ${error}`);
  });

  const fetchPromise3 = fetch(
      "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json",
  );
  const fetchPromise4 = fetch(
      "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/not-found",
  );
  const fetchPromise5 = fetch(
      "https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json",
  );

  Promise.all([fetchPromise3, fetchPromise4, fetchPromise5])
    .then((responses) => {
      console.log("Trying Promise.all, Good URLs: ");
      for (const response of responses) {
        console.log(`${response.url}: ${response.status}`);
      }
    })
    .catch((error) => {
      console.log("Trying Promise.all, Good URLs: ");
      console.error(`Failed to fetch: ${error}`);
    });

  const fetchPromise6 = fetch(
    "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json",
  );
  const fetchPromise7 = fetch(
    "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/not-found",
  );
  const fetchPromise8 = fetch(
    "bad-scheme://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json",
  );

  Promise.all([fetchPromise6, fetchPromise7, fetchPromise8])
    .then((responses) => {
      console.log("Trying Promise.all, BAD URLs: ");
      for (const response of responses) {
        console.log(`${response.url}: ${response.status}`);
      }
    })
    .catch((error) => {
      console.log("Trying Promise.all, BAD URLs: ");
      console.error(`Failed to fetch: ${error}`);
    });

  const fetchPromise9 = fetch(
    "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/products.json",
  );
  const fetchPromise10 = fetch(
    "https://mdn.github.io/learning-area/javascript/apis/fetching-data/can-store/not-found",
  );
  const fetchPromise11 = fetch(
    "https://mdn.github.io/learning-area/javascript/oojs/json/superheroes.json",
  );

  Promise.any([fetchPromise9, fetchPromise10, fetchPromise11])
    .then((response) => {
      console.log("Trying Promise.any: ");
      console.log(`${response.url}: ${response.status}`);
    })
    .catch((error) => {
      console.log("Trying Promise.any: ");
      console.error(`Failed to fetch: ${error}`);
    });