import React from "react";

class AnimalForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      "animal[name]": props.animal.name || "",
      "animal[birth_date]": props.animal.birth_date || "",
      "animal[is_vaccinated]": props.animal.is_vaccinated ? 1 : 0,
      "animal[species_id]": props.animal.species_id || ""
    };
  }

  handleChange = event => {
    this.setState({
      [event.target.name]:
        event.target.type === "checkbox"
          ? event.target.checked
          : event.target.value
    });
  };

  render() {
    return (
      <form method="POST" action="/animals/react_create">
        <input
          type="hidden"
          name="authenticity_token"
          value={this.props.authenticity_token}
        />
        <label>
          Name:
          <input
            required
            name="animal[name]"
            value={this.state["animal[name]"]}
            onChange={this.handleChange}
            type="text"
          />
        </label>
        <br />
        <label>
          Name:
          <input
            required
            name="animal[birth_date]"
            value={this.state["animal[birth_date]"]}
            onChange={this.handleChange}
            type="date"
          />
        </label>
        <br />
        <label>
          Is vaccinated:
          <input type="hidden" value="0" name="animal[is_vaccinated]" />
          <input
            name="animal[is_vaccinated]"
            id="animal_is_vaccinated"
            checked={!!this.state["animal[is_vaccinated]"]}
            onChange={this.handleChange}
            // crazy case where checked box actually passes
            // whatever value is present in value attribute
            // and an unchecked box is NOT posted by browser
            // so must preface with hidden value 0 with
            // same field name to get one or the other to pass
            value="1"
            type="checkbox"
          />
        </label>
        <br />
        <label>
          Species:
          <select
            required
            name="animal[species_id]"
            value={this.props.species_id}
            onChange={this.handleChange}
          >
            <option key="-1" />
            {this.props.species.map((species, index) => (
              <option key={index} value={species.id}>
                {species.name}
              </option>
            ))}
          </select>
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}

export default AnimalForm;
