

function Form({id,type}) {
  return (
    <>
      <form>
        <h2 className="label-wrapper">
          <label htmlFor={id} className="label__lg">
            What needs to be done?
          </label>
        </h2>
        <input
          type={type}
          id={id}
          className="input input__lg"
          name="text"
          autoComplete="off"
        />
        <button type="submit" className="btn btn__primary btn__lg">
          Add
        </button>
      </form>    </>
  )
}

export default Form
