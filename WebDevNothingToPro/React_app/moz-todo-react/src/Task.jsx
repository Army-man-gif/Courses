import { useState } from "react";

function Task({name,id,isChecked,toggleTaskCompleted,deleteTask}){
  const [isEditing, setEditing] = useState(false);
  const editTemplate = (
    <>
          <div className="c-cb">
            <input id={id} type="checkbox" defaultChecked={isChecked} name={name} key={id} onChange={() => toggleTaskCompleted(id)} />
            <label className="todo-label" htmlFor={id}>
              {name}
            </label>
          </div>
          <div className="btn-group">
            <button type="button" className="btn">
              Cancel <span className="visually-hidden">renaming {name}</span>
            </button>
            <button type="button" className="btn btn__danger" onClick={() => deleteTask(id)} >
              Save <span className="visually-hidden">renaming {name}</span>
            </button>
          </div>
    </>
  );
  const viewTemplate = (
    <>
          <div className="c-cb">
            <input id={id} type="checkbox" defaultChecked={isChecked} name={name} key={id} onChange={() => toggleTaskCompleted(id)} />
            <label className="todo-label" htmlFor={id}>
              {name}
            </label>
          </div>
          <div className="btn-group">
            <button type="button" className="btn">
              Edit <span className="visually-hidden">{name}</span>
            </button>
            <button type="button" className="btn btn__danger" onClick={() => deleteTask(id)} >
              Delete <span className="visually-hidden">{name}</span>
            </button>
          </div>
    </>
  );
  return (
    <>
      {isEditing ? editTemplate : viewTemplate};
    </>
  )
}

export default Task