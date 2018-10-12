import React from "react";
import { Jumbotron, Button } from "reactstrap";
import Menu from "components/Menu.jsx";

class HomePage extends React.Component {
  /* eslint class-methods-use-this: "error" */
  render() {
    return (
      <div>
        <Menu />
        <Jumbotron className="text-center">
          <h3>Let&apos;s manage some things!</h3>
          <p className="lead">
            Animals (and in future Vegetables and Minerals) need management
          </p>
          <p>Feel free to manage some things!</p>
        </Jumbotron>
      </div>
    );
  }
}

export default HomePage;
