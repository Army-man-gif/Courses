function App(props) {
  return (
    <>
      <header>
        {/*<h1>I'm trying to make a {subject} app for the first time, assisted by the "vite" build tool</h1>*/}
        <h1>{props.subject}</h1>
        <button type="button" className="primary"> Click me! </button>
        {/*<p>Hello, {`${subject} :)`}!</p>
        <p>Hello, {subject.toUpperCase()}</p>*/}
        <p>Hello, {2 + 2}!</p>
      </header>

    </>
  )
}

export default App
