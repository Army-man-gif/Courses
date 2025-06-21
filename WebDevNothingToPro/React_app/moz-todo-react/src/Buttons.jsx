function Button({first,second,third,isPressed}){
  return (

        <button type="button" className="btn toggle-btn" aria-pressed={isPressed}>

          <span className="visually-hidden">{first} </span>

          <span>{second}</span>

          <span className="visually-hidden"> {third}</span>

        </button>
  )
}

export default Button