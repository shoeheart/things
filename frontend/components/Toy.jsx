import React from "react";

class Toy extends React.Component {
  render() {
    const { toy } = this.props;
    return (
      <tr>
        <td>{toy.toy_type_name}</td>
        <td>{toy.acquired_on}</td>
      </tr>
    );
  }
}

export default Toy;
