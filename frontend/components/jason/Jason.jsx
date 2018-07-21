import React from "react";
import NumberList from "./NumberList.jsx";
import NameForm from "./NameForm.jsx";

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

  doubleCounts() {
    const myCount = this.state.count;
    const myCountArray = [];
    for (let i = 0; i < 5; i++) {
      myCountArray[i] = myCount + i;
    }
    return myCountArray.map(number => number * 2);
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
          doubled 5 counts: <br />
          <NumberList numberList={this.doubleCounts()} />
        </div>
        <div>
          <span>It is {this.state.date.toLocaleTimeString()}.</span>
        </div>
        <NameForm />
      </div>
    );
  }
}

export default Jason;
