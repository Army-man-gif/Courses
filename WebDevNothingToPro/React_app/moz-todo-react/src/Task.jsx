function Task({name,id}){
  return(
    <>
          <div className="c-cb">
            <input id={id} type="checkbox" defaultChecked />
            <label className="todo-label" htmlFor={id}>
              {name}
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
    </>
  )
}

export default Task