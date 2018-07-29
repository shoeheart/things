import React from "react";
import Menu from "components/Menu.jsx";
import Toys from "components/Toys.jsx";
import AnimalForm from "components/AnimalForm.jsx";
import AuditTrail from "components/AuditTrail.jsx";
import { Card, CardHeader, CardBody } from "reactstrap";

class AnimalPage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <Card>
          <CardHeader>Animal Info</CardHeader>
          <CardBody>
            <AnimalForm
              animal={this.props.animal}
              species={this.props.species}
              authenticity_token={this.props.authenticity_token}
            />
          </CardBody>
        </Card>
        <Card>
          <CardHeader>Toys owned by this Animal</CardHeader>
          <CardBody>
            {this.props.versions ? (
              <Toys toys={this.props.toys} />
            ) : (
              "(No toys owned)"
            )}
          </CardBody>
        </Card>
        {this.props.versions ? (
          <Card>
            <CardHeader>Animal Audit Trail</CardHeader>
            <CardBody>
              <AuditTrail trail={this.props.versions} />
            </CardBody>
          </Card>
        ) : (
          ""
        )}
      </div>
    );
  }
}

export default AnimalPage;
