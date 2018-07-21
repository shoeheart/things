import React from "react";
import PropTypes from "prop-types";

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
