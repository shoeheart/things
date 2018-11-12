import React from "react";
import Menu from "components/Menu.jsx";
import { Col, Row, Container } from "reactstrap";
import NumberWidget from "components/Widget/NumberWidget.jsx";
import * as d3 from "d3";

const axios = require("axios");

class DashboardPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      counts: this.props.counts,
      refreshes: 0,
      chart_data: [
        {
          label: "Animals",
          adopted: this.props.counts.animals_adopted,
          sheltered: this.props.counts.animals_sheltered,
          died: 0 - this.props.counts.animals_died
        }
      ]
    };
  }

  componentDidMount() {
    this.timerID = setInterval(() => this.tick(), 200);
    this.initializeGraph();
    // DashboardPage.drawNumbers();
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
          refreshes: this.state.refreshes + 1,
          chart_data: [
            {
              label: "Animals",
              adopted: response.data.animals_adopted,
              sheltered: response.data.animals_sheltered,
              died: 0 - response.data.animals_died
            }
          ]
        });
      })
      .catch(() => {
        // console.log( "axios error:" );
        // console.log( response );
        // TODO: handle error here
      });
    this.updateGraph();
  }

  static stackMin(serie) {
    return d3.min(serie, d => d[0]);
  }

  static stackMax(serie) {
    return d3.max(serie, d => d[1]);
  }

  static drawNumbers() {
    d3.select("#jason")
      .selectAll("p")
      .data([4, 8, 15, 16, 23, 42])
      .enter()
      .append("p")
      .text(d => `I’m number ${d}!`);
  }

  initializeGraph() {
    /* eslint class-methods-use-this: "error" */

    const series = d3
      .stack()
      .keys(["adopted", "sheltered", "died"])
      .offset(d3.stackOffsetDiverging)(this.state.chart_data);

    const svg = d3.select("svg");

    const margin = { top: 20, right: 30, bottom: 30, left: 60 };

    const width = 0 + svg.attr("width");

    const height = 0 + svg.attr("height");

    const x = d3
      .scaleBand()
      .domain(this.state.chart_data.map(d => d.label))
      .rangeRound([margin.left, width - margin.right])
      .padding(0.1);

    const y = d3
      .scaleLinear()
      .domain([
        d3.min(series, DashboardPage.stackMin),
        d3.max(series, DashboardPage.stackMax)
      ])
      .rangeRound([height - margin.bottom, margin.top]);

    const z = d3.scaleOrdinal(d3.schemeCategory10);

    // svg
    //   .transition()
    //   .duration(3000)
    //   .style("background-color", "yellow");

    svg
      .append("g")
      .selectAll("g")
      .data(series)
      .enter()
      .append("g")
      .attr("fill", d => z(d.key))
      .selectAll("rect")
      .data(d => d)
      .enter()
      .append("rect")
      .attr("width", x.bandwidth)
      .attr("x", d => x(d.data.label))
      .attr("y", d => y(d[1]))
      .attr("height", d => y(d[0]) - y(d[1]));

    svg
      .append("g")
      .attr("transform", `translate(0,${y(0)})`)
      .call(d3.axisBottom(x));

    svg
      .append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(d3.axisLeft(y));
  }

  updateGraph() {
    /* eslint class-methods-use-this: "error" */

    const series = d3
      .stack()
      .keys(["adopted", "sheltered", "died"])
      .offset(d3.stackOffsetDiverging)(this.state.chart_data);

    const svg = d3.select("svg");

    const margin = { top: 20, right: 30, bottom: 30, left: 60 };

    const width = 0 + svg.attr("width");

    const height = 0 + svg.attr("height");

    const x = d3
      .scaleBand()
      .domain(this.state.chart_data.map(d => d.label))
      .rangeRound([margin.left, width - margin.right])
      .padding(0.1);

    const y = d3
      .scaleLinear()
      .domain([
        d3.min(series, DashboardPage.stackMin),
        d3.max(series, DashboardPage.stackMax)
      ])
      .rangeRound([height - margin.bottom, margin.top]);

    const z = d3.scaleOrdinal(d3.schemeCategory10);

    // svg
    //   .selectAll("g")
    //   .data(series)
    //   .selectAll("g")
    //   .attr("fill", d => {
    //     console.log(d);
    //     console.log(d.key);
    //     console.log(z(d.key));
    //     return z(d.key);
    //   })
    //   .selectAll("rect")
    //   .data(d => d)
    //   .attr("x", d => {
    //     console.log(d);
    //     console.log(d.data);
    //     console.log(d.data.label);
    //     console.log(x(d.data.label));
    //     return x(d.data.label);
    //   })
    //   .attr("y", d => {
    //     console.log(d);
    //     console.log(d[1]);
    //     console.log(y(d[1]));
    //     return y(d[1]);
    //   })
    //   .attr("height", d => {
    //     console.log(d);
    //     console.log(d[0]);
    //     console.log(d[1]);
    //     console.log(y(d[0] - d[1]));
    //     return y(d[0]) - y(d[1]);
    //   });

    svg.selectAll("g").remove();

    svg
      .append("g")
      .selectAll("g")
      .data(series)
      .enter()
      .append("g")
      .attr("fill", d => z(d.key))
      .selectAll("rect")
      .data(d => d)
      .enter()
      .append("rect")
      .attr("width", x.bandwidth)
      .attr("x", d => x(d.data.label))
      .attr("y", d => y(d[1]))
      .attr("height", d => y(d[0]) - y(d[1]));

    svg
      .append("g")
      .attr("transform", `translate(0,${y(0)})`)
      .call(d3.axisBottom(x));

    svg
      .append("g")
      .attr("transform", `translate(${margin.left},0)`)
      .call(d3.axisLeft(y));
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
        </Container>
        <svg width="960" height="500" />
        <div id="jason" />
      </div>
    );
  }
}

export default DashboardPage;
