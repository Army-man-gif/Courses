import "./App_replacedcss.css"
import Form from './Form.jsx'
import Buttons from './Buttons.jsx'
import Task from './Task.jsx'
import { useState } from "react";
import { nanoid } from "nanoid";


function App() {
  
  function editTask(id, newName){
    const editedTasks = currentVal.map((task) => {
      if (id === task.id){
        console.log(task);
        return {...task, name: newName}
      }
      return task;
    })
    setValues(editedTasks);
  }
  
  function deleteTask(id){
    const remainingTasks = currentVal.filter((task) => id !== task.id);
    setCount(count-1)
    setValues(remainingTasks);

  }
  function toggleTaskCompleted(id) {
    const updatedTasks = currentVal.map((task) => {
      if (id === task.id){
        console.log(task);
        return {...task, isChecked: !task.isChecked}
      }
      return task;

    })
    setValues(updatedTasks);

  }
  function addTask(name){
    const newValue = {id:`todo-${nanoid()}`,name:name,isChecked:false}
    setValues([...currentVal,newValue]);
    setCount(count+1)
  }
  const values = [
    { id: "todo-0", name: "Eat", isChecked: true },
    { id: "todo-1", name: "Sleep", isChecked: false },
    { id: "todo-2", name: "Repeat", isChecked: false },
  ];

  const [currentVal,setValues] = useState(values);
  const [count,setCount] = useState(currentVal.length);
  let countNoun = "tasks";
  if(count==1){
    countNoun = "task";
  }
  const [filter, setFilter] = useState("All");
  const FILTER_MAP = {
    All: () => true,
    Active: (task) => !task.isChecked,
    Completed: (task) => task.isChecked,
  };
  const FILTER_NAMES = Object.keys(FILTER_MAP);
  const filterList = FILTER_NAMES.map((name) => (
    <Buttons 
      val={name} 
      isPressed={name === filter}
      setFilter={setFilter}
     />
  ));
  return (
    <div className="todoapp stack-la  rge">
      <h1>TodoMatic</h1>
      <Form id="new-todo-input" type="text" addTask={addTask}/>
      <div className="filters btn-group stack-exception">{filterList}</div>

      <h2 id="list-heading">{count} {countNoun} remaining</h2>
      
      <ul
        role="list"
        className="todo-list stack-large stack-exception"
        aria-labelledby="list-heading">
        {currentVal.map((task)=>(
          <li key={task.id} className="todo stack-small">
            <Task 
              id={task.id} 
              name={task.name} 
              isChecked={task.isChecked} 
              toggleTaskCompleted={toggleTaskCompleted}
              deleteTask={deleteTask}
              editTask={editTask}
            />
          </li>
        ))}
      </ul>
        
    </div>
  );
}

export default App;