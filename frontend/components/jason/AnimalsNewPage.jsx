import React from "react";
import Menu from "components/jason/Menu.jsx";
import AnimalForm from "components/jason/AnimalForm.jsx";

class AnimalsNewPage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <AnimalForm
          animal={this.props.animal}
          species={this.props.species}
          authenticity_token={this.props.authenticity_token}
        />
      </div>
    );
  }
}

export default AnimalsNewPage;
