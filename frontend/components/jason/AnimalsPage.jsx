import React from "react";
import Menu from "components/jason/Menu.jsx";
import Animals from "components/jason/Animals.jsx";

class AnimalsPage extends React.Component {
  /* eslint class-methods-use-this: "off" */
  render() {
    return (
      <div>
        <Menu />
        <Animals animals={this.props.animals} />
      </div>
    );
  }
}

export default AnimalsPage;
