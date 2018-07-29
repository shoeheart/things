import React from "react";
import { Jumbotron, Card, CardBody, CardTitle } from "reactstrap";
import Menu from "./Menu.jsx";

class ProfilePage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <Jumbotron className="jumbo-thumbnail">
          <h3>Welcome, {this.props.user_name}!</h3>
          <img src={this.props.user_image} />
        </Jumbotron>
        <Card>
          <CardBody>
            <CardTitle>Permissions</CardTitle>
            <pre>{this.props.permissions}</pre>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Normalized User Profile</CardTitle>
            <pre>{this.props.normalized_user_profile}</pre>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Full User Profile</CardTitle>
            <pre>{this.props.full_user_profile}</pre>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Full OmniAuth Hash</CardTitle>
            <pre>{this.props.full_omniauth_hash}</pre>
          </CardBody>
        </Card>
      </div>
    );
  }
}

export default ProfilePage;
