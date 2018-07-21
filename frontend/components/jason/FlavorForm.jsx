import React from "react";

class FlavorForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: "cherry"
    };
  }

  handleChange = event => {
    this.setState({ value: event.target.value });
  };

  handleSubmit = event => {
    alert(`Favorite flavor submitted as: ${this.state.value}`);
    event.preventDefault();
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Choose favorite flavor:
          <select value={this.state.value} onChange={this.handleChange}>
            <option value="apple">Apple</option>
            <option value="banana">Banana</option>
            <option value="cherry">Cherry</option>
          </select>
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}

export default FlavorForm;
