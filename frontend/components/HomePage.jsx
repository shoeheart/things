import React from "react";
import { Jumbotron } from "reactstrap";
import Menu from "components/Menu.jsx";

class HomePage extends React.Component {
  /* eslint class-methods-use-this: "off" */
  render() {
    return (
      <div>
        <Menu />
        <Jumbotron className="text-center">
          <h3>Let&apos;s manage some things!</h3>
          <p className="lead">
            Animals (and in future Vegetables and Minerals) need management
          </p>
        </Jumbotron>
        The system has background recurring jobs that make the system record
        data for events including:
        <ul>
          <li>New Animal given to shelter</li>
          <li>Animal gets adopted by Person</li>
          <li>Animal that is already adopted is given a Toy</li>
          <li>
            Oldest of adopted Animal dies, freeing up a position for a new
            AnimalAdoption
          </li>
        </ul>
      </div>
    );
  }
}

export default HomePage;
