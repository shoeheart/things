import React from "react";
import Menu from "components/Menu.jsx";
import { Card, CardTitle, CardSubtitle, CardBody } from "reactstrap";

const axios = require("axios");

class DashboardPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      counts: this.props.counts,
      refreshes: 0
    };
  }

  componentDidMount() {
    this.timerID = setInterval(() => this.tick(), 500);
  }

  componentWillUnmount() {
    this.clearInterval(this.timerID);
  }

  tick() {
    axios
      .get("/dashboard/counts")
      .then(response => {
        // console.log( "axios success:" );
        // console.log( response );
        this.setState({
          counts: response.data,
          refreshes: this.state.refreshes + 1
        });
      })
      .catch(() => {
        // console.log( "axios error:" );
        // console.log( response );
        // TODO: handle error here
      });
  }

  render() {
    return (
      <div>
        <Menu />
        <Card>
          <CardBody>
            <CardTitle>Animals Adopted</CardTitle>
            <CardSubtitle>{this.state.counts.animals_adopted}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Animals Sheltered</CardTitle>
            <CardSubtitle>{this.state.counts.animals_sheltered}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Animals Died</CardTitle>
            <CardSubtitle>{this.state.counts.animals_died}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Total People</CardTitle>
            <CardSubtitle>{this.state.counts.people}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>People Who Have Adopted</CardTitle>
            <CardSubtitle>
              {this.state.counts.people_who_have_adopted}
            </CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>People Eligible to Adopt</CardTitle>
            <CardSubtitle>
              {this.state.counts.people_eligible_to_adopt}
            </CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>People Who Have Not Adopted</CardTitle>
            <CardSubtitle>
              {this.state.counts.people_who_have_not_adopted}
            </CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Toys Owned by Adopted Animals</CardTitle>
            <CardSubtitle>{this.state.counts.toys_owned}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Toys Lost by Animals who have Died</CardTitle>
            <CardSubtitle>{this.state.counts.toys_lost}</CardSubtitle>
          </CardBody>
        </Card>
        <Card>
          <CardBody>
            <CardTitle>Dashboard Refreshes</CardTitle>
            <CardSubtitle>{this.state.refreshes}</CardSubtitle>
          </CardBody>
        </Card>
      </div>
    );
  }
}

export default DashboardPage;
