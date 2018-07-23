import React from "react";
import Menu from "components/jason/Menu.jsx";
import AnimalForm from "components/jason/AnimalForm.jsx";

class AnimalsNewPage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    const authenticityToken = document.head.querySelector(
      'meta[name="csrf-token"]'
    ).content;
    return (
      <div>
        <Menu />
        <AnimalForm
          authenticity_token={authenticityToken}
          animal={this.props.animal}
          species={this.props.species}
        />
      </div>
    );
  }
}

export default AnimalsNewPage;
