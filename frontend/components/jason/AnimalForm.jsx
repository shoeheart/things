import React from "react";

const axios = require("axios");

class AnimalForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      "animal[id]": props.animal.id,
      "animal[name]": props.animal.name,
      "animal[birth_date]": props.animal.birth_date,
      "animal[is_vaccinated]": props.animal.is_vaccinated ? 1 : 0,
      "animal[species_id]": props.animal.species_id
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

  handleSubmit = event => {
    event.preventDefault();
    const patchUrl = `/animals/${this.state["animal[id]"]}/react_update_json`;
    const body = {
      authenticity_token: this.props.authenticity_token,
      animal: {
        name: this.state["animal[name]"],
        birth_date: this.state["animal[birth_date]"],
        is_vaccinated: this.state["animal[is_vaccinated]"],
        species_id: this.state["animal[species_id]"]
      }
    };
    (this.state["animal[id]"]
      ? axios.patch(patchUrl, body)
      : axios.post("/animals/react_create_json", body)
    )
      .then(response => {
        // console.log( "axios success:" );
        // console.log( response );
        window.location.href = response.data.redirect_to;
      })
      .catch(() => {
        // console.log( "axios error:" );
        // console.log( response );
        // TODO: handle error here
      });
  };

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
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
          <input
            name="animal[is_vaccinated]"
            checked={!!this.state["animal[is_vaccinated]"]}
            onChange={this.handleChange}
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
            value={this.state["animal[species_id]"]}
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
        <label>
          Images:
          <input
            multiple="multiple"
            data-direct-upload-url="/rails/active_storage/direct_uploads"
            type="file"
            name="animal[images][]"
            id="animal_images"
          />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}

export default AnimalForm;
