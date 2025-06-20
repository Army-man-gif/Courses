import "./App_replacedcss.css"
import Form from './Form.jsx'
import Buttons from './Buttons.jsx'
import Tasks from './Tasks.jsx'

function App() {
  return (
    <div className="todoapp stack-large">
      <h1>TodoMatic</h1>
      <Form/>
      <Button/>
      <h2 id="list-heading">3 tasks remaining</h2>
      <Tasks/>
    </div>
  );
}

export default App;