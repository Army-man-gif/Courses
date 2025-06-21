import "./App_replacedcss.css"
import Form from './Form.jsx'
import Buttons from './Buttons.jsx'
import Task from './Task.jsx'

function App() {
  return (
    <div className="todoapp stack-large">
      <h1>TodoMatic</h1>
      <Form id="new-todo-input" type="text"/>
      <div className="filters btn-group stack-exception">
        <Buttons first="Show" second="All" third="tasks"/>
        <Buttons first="Show" second="Active" third="tasks"/>
        <Buttons first="Show" second="Completed" third="tasks"/>
      </div>
      <h2 id="list-heading">3 tasks remaining</h2>
      <ul
        role="list"
        className="todo-list stack-large stack-exception"
        aria-labelledby="list-heading">
        <li className="todo stack-small">
          <Task id="todo-0" name="Eat"/>
        </li>
        <li className="todo stack-small">
          <Task id="todo-1" name="Sleep"/>
        </li>
        <li className="todo stack-small">
          <Task id="todo-2" name="Repeat"/>
        </li>
      </ul>
        
    </div>
  );
}

export default App;