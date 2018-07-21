import React from "react";
import { Table } from "reactstrap";
import Animal from "./Animal.jsx";

class Animals extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <Table striped>
        <thead>
          <tr>
            <th>Name</th>
            <th>Species</th>
            <th>Toy Count</th>
          </tr>
        </thead>
        <tbody>
          {this.props.animals.map(animal => (
            <Animal key={animal.id} animal={animal} />
          ))};
        </tbody>
      </Table>
    );
  }
}

export default Animals;
