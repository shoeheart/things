import React from "react";
import { Col, Form, FormGroup, Label, Input } from "reactstrap";

const axios = require("axios");

class AnimalForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      "animal[id]": props.animal.id || "",
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

  handleSubmit = event => {
    event.preventDefault();
    const patchUrl = `/animals/${this.state["animal[id]"]}`;
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
      : axios.post("/animals", body)
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
      <Form onSubmit={this.handleSubmit}>
        <FormGroup row>
          <Label for="email" sm={1}>
            Name
          </Label>
          <Col sm={5}>
            <Input
              required
              id="email"
              name="animal[name]"
              value={this.state["animal[name]"]}
              onChange={this.handleChange}
              type="text"
            />
          </Col>
        </FormGroup>
        <FormGroup row>
          <Label for="birth_date" sm={1}>
            Birth Date
          </Label>
          <Col sm={5}>
            <Input
              required
              id="birth_date"
              name="animal[birth_date]"
              value={this.state["animal[birth_date]"]}
              onChange={this.handleChange}
              type="text"
            />
          </Col>
        </FormGroup>
        <FormGroup row>
          <Label for="is_vaccinated" sm={1}>
            Is Vaccinated
          </Label>
          <Col sm={5}>
            <Input
              id="is_vaccinated"
              name="animal[is_vaccinated]"
              checked={!!this.state["animal[is_vaccinated]"]}
              value="1"
              onChange={this.handleChange}
              type="checkbox"
            />
          </Col>
        </FormGroup>
        <FormGroup row>
          <Label for="species_id" sm={1}>
            Species:
          </Label>
          <Col sm={5}>
            <Input
              required
              type="select"
              id="species_id"
              name="animal[species_id]"
              checked={!!this.state["animal[species_id]"]}
              value={this.state["animal[species_id]"]}
              onChange={this.handleChange}
            >
              <option key="-1" />
              {this.props.species.map((species, index) => (
                <option key={index} value={species.id}>
                  {species.name}
                </option>
              ))}
            </Input>
          </Col>
        </FormGroup>
        <Input type="submit" value="Submit" />
      </Form>
    );
  }
}

export default AnimalForm;
