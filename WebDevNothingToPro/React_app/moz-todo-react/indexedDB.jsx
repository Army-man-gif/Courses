

function database(){
    let db;
    const openRequest = window.indexedDB.open("notes_db", 1);
    // error handler signifies that the database didn't open successfully
    openRequest.addEventListener("error", () =>
        console.error("Database failed to open"),
    );

    // success handler signifies that the database opened successfully
    openRequest.addEventListener("success", () => {
        console.log("Database opened successfully");

        // Store the opened database object in the db variable. This is used a lot below
        db = openRequest.result;

        // Run the displayData() function to display the notes already in the IDB
        displayData();
    });
    return (
        <>
        </>
    )
}


export default database;