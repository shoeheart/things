import React from "react";
import { Button } from "reactstrap";
import Menu from "components/Menu.jsx";
import Animals from "components/Animals.jsx";

class AnimalsIndexPage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <Button href="/animals/new">Add Animal</Button>
        <Animals animals={this.props.animals} />
      </div>
    );
  }
}

export default AnimalsIndexPage;
