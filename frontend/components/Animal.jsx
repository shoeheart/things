import React from "react";
import { Button } from "reactstrap";

class Animal extends React.Component {
  render() {
    const { animal } = this.props;
    return (
      <tr>
        <td>{animal.name}</td>
        <td>{animal.species_name}</td>
        <td>{animal.toy_count}</td>
        <td>
          <Button href={`/animals/${animal.id}/edit`}>Edit</Button>
        </td>
      </tr>
    );
  }
}

export default Animal;
