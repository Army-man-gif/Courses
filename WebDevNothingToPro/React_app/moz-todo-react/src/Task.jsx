function Task({name,id}){
  return(
    <span>
          <div className="c-cb">
            <input id={id} type="checkbox" defaultChecked />
            <label className="todo-label" htmlFor={id}>
              Eat
            </label>
          </div>
          <div className="btn-group">
            <button type="button" className="btn">
              Edit <span className="visually-hidden">{name}</span>
            </button>
            <button type="button" className="btn btn__danger">
              Delete <span className="visually-hidden">{name}</span>
            </button>
          </div>
          <div className="c-cb">
            <input id="todo-1" type="checkbox" />
            <label className="todo-label" htmlFor="todo-1">
              Sleep
            </label>
          </div>
    </span>
  )
}

export default Task