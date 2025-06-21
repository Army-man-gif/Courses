import { useState } from "react";

function Task({name,id,isChecked,toggleTaskCompleted,deleteTask,editTask}){
  const [isEditing, setEditing] = useState(false);
  const [newName, setNewName] = useState(name);
  function handleSubmit(e) {
    e.preventDefault();
    editTask(id, newName);
    setEditing(false);
  }
  function handleChange(e) {
    setNewName(e.target.value);
  }
  const editTemplate = (
      <form onSubmit={handleSubmit}>
          <div className="c-cb">
            <input id={`edit-${id}`} type="text" value={newName} key={id} onChange={handleChange} />
            <label className="todo-label" htmlFor={`edit-${id}`}>
              {newName}
            </label>
          </div>
          <div className="btn-group">
            <button type="button" className="btn" onClick={() => setEditing(false)}>
              Cancel <span className="visually-hidden">renaming {newName}</span>
            </button>
            <button type="submit" className="btn btn__danger">
              Save <span className="visually-hidden">renaming {newName}</span>
            </button>
          </div>
      </form>
  );
  const viewTemplate = (
    <>
          <div className="c-cb">
            <input id={`view-${id}`} type="checkbox" defaultChecked={isChecked} onChange={() => toggleTaskCompleted(id)} />
            <label className="todo-label" htmlFor={`view-${id}`}>
              {newName}
            </label>
          </div>
          <div className="btn-group">
            <button type="button" className="btn" onClick={() => setEditing(true)}>
              Edit <span className="visually-hidden">{newName}</span>
            </button>
            <button type="button" className="btn btn__danger" onClick={() => deleteTask(id)} >
              Delete <span className="visually-hidden">{newName}</span>
            </button>
          </div>
    </>
  );
  console.log("Rendering", isEditing ? "edit mode" : "view mode");
  return (
    <>
      {isEditing ? editTemplate : viewTemplate}
    </>
  )
}

export default Task