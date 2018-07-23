import React from "react";
import Menu from "components/jason/Menu.jsx";
import Animals from "components/jason/Animals.jsx";

class AnimalsIndexPage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <Animals animals={this.props.animals} />
      </div>
    );
  }
}

export default AnimalsIndexPage;
