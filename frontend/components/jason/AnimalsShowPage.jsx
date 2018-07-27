import React from "react";
import Menu from "components/jason/Menu.jsx";
import AnimalForm from "components/jason/AnimalForm.jsx";
import AuditTrail from "components/jason/AuditTrail.jsx";

class AnimalsShowPage extends React.Component {
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
        {this.props.versions ? <AuditTrail trail={this.props.versions} /> : ""}
      </div>
    );
  }
}

export default AnimalsShowPage;
