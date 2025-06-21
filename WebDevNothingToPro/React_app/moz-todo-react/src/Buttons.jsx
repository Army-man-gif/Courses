function Button({val,isPressed}){
  return (

        <button type="button" className="btn toggle-btn" aria-pressed={isPressed}>

          <span className="visually-hidden">Show </span>

          <span>{val}</span>

          <span className="visually-hidden">tasks</span>

        </button>
  )
}

export default Button