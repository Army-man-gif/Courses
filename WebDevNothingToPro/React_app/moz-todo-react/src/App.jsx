import './App.css'


const subject = "REACT";
function App() {
  return (
    <>
      <header>
        <h1>I'm trying to make a {subject} app for the first time, assisted by the "vite" build tool</h1>
        <button type="button" className="primary"> Click me! </button>
        <p>Hello, {`${subject} :)`}!</p>
        <p>Hello, {subject.toUpperCase()}</p>
        <p>Hello, {2 + 2}!</p>
      </header>

    </>
  )
}

export default App
