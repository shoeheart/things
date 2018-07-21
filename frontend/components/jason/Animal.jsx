import React from "react";

class Animal extends React.Component {
  render() {
    const { animal } = this.props;
    return (
      <tr>
        <td>{animal.name}</td>
        <td>{animal.species_name}</td>
        <td>{animal.toy_count}</td>
      </tr>
    );
  }
}

export default Animal;
