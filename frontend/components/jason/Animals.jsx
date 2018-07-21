import React from "react";
import Animal from "./Animal.jsx";

class Animals extends React.Component {
  /* eslint class-methods-use-this: "off" */
  render() {
    return (
      <table className="table">
        <thead className="thead-light">
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
      </table>
    );
  }
}

export default Animals;
