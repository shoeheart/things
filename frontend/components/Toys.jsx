import React from "react";
import { Table } from "reactstrap";
import Toy from "components/Toy.jsx";

class Toys extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Table striped>
          <thead>
            <tr>
              <th>Toy Type</th>
              <th>Acquired On</th>
            </tr>
          </thead>
          <tbody>
            {this.props.toys.map(toy => (
              <Toy key={toy.id} toy={toy} />
            ))}
          </tbody>
        </Table>
      </div>
    );
  }
}

export default Toys;
