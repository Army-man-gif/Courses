import "./App_replacedcss.css"
import Form from './Form.jsx'
import Buttons from './Buttons.jsx'
import Task from './Task.jsx'

function App() {
  function addTask(name){
    alert(name);
  }
  const values = [
    { id: "todo-0", name: "Eat", isChecked: true },
    { id: "todo-1", name: "Sleep", isChecked: false },
    { id: "todo-2", name: "Repeat", isChecked: false },
  ];
  return (
    <div className="todoapp stack-la  rge">
      <h1>TodoMatic</h1>
      <Form id="new-todo-input" type="text" addTask={addTask}/>
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
        {values.map((task)=>(
          <li key={task.id} className="todo stack-small">
            <Task id={task.id} name={task.name} isChecked={task.isChecked}/>
          </li>
        ))}
      </ul>
        
    </div>
  );
}

export default App;