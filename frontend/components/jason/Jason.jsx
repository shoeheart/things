import React from "react";

// stateless functional components
// takes in properties and renders something
// purely an output of input
// const Jason = props => (
//   <div>Jason {props.greeting}!</div>
// );

// std def for react compoment
// this.props contains the properties passed to component invocation
// this.state is predfined name for where to store component state
class Jason extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      count: 0,
      height: 10,
      date: new Date()
    };
  }

  componentDidMount() {
    this.timerID = setInterval(() => this.tick(), 1000);
  }

  componentWillUnmount() {
    this.clearInterval(this.timerID);
  }

  tick() {
    this.setState({ date: new Date() });
  }

  // fat arrow binds to context of this when its defined
  // which avoids needing to do
  // this.changeStuff.bind(this) below
  changeStuff = () => {
    this.setState({
      count: this.state.count + 1,
      height: this.state.height - 1
    });
  };

  render() {
    return (
      <div>
        <button onClick={this.changeStuff}>click me</button>
        <div>
          {this.props.greeting} Jason! <br />
          count: {this.state.count} <br />
          height: {this.state.height} <br />
        </div>
        <div>
          <span>It is {this.state.date.toLocaleTimeString()}.</span>
        </div>
      </div>
    );
  }
}

export default Jason;
