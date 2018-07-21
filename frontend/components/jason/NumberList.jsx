import React from "react";
import PropTypes from "prop-types";

// stateless functional components
// takes in properties and renders something
// purely an output of input
// const Jason = props => (
//   <div>Jason {props.greeting}!</div>
// );

// std def for react compoment
// this.props contains the properties passed to component invocation
// this.state is predfined name for where to store component state
class NumberList extends React.Component {
  static propTypes: {
    numberList: PropTypes.array.isRequired
  };
  render() {
    return (
      <div>
        <ul>
          {this.props.numberList.map((number, index) => (
            <li key={index}>{number}</li>
          ))}
        </ul>
      </div>
    );
  }
}

export default NumberList;
