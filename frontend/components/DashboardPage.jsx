import React from "react";
import Menu from "components/Menu.jsx";
import { Col, Row, Container } from "reactstrap";
import NumberWidget from "components/Widget/NumberWidget.jsx";

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
        <Container>
          <Row>
            {/*
            <Col lg={3} md={6} sm={6} xs={12}>
            */}
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Animals Adopted"
                number={this.state.counts.animals_adopted}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Animals Sheltered"
                number={this.state.counts.animals_sheltered}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Animals Died"
                number={this.state.counts.animals_died}
                color="secondary"
              />
            </Col>
          </Row>
          <hr />
          <Row>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Total people"
                number={this.state.counts.people}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="People who have adopted"
                number={this.state.counts.people_who_have_adopted}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="People eligible to adopt"
                number={this.state.counts.people_eligible_to_adopt}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="People who have not adopted"
                number={this.state.counts.people_who_have_not_adopted}
                color="secondary"
              />
            </Col>
          </Row>
          <hr />
          <Row>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Toys owned by adopted animals"
                number={this.state.counts.toys_owned}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Toys lost by dead animals"
                number={this.state.counts.toys_lost}
                color="secondary"
              />
            </Col>
            <Col lg={3} md={6} sm={6} xs={12}>
              <NumberWidget
                title="Dashboard refreshes"
                number={this.state.refreshes}
                color="secondary"
              />
            </Col>
          </Row>
          {/*
          */}
        </Container>
      </div>
    );
  }
}

export default DashboardPage;
