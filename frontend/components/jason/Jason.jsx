import React, { Component } from 'react'

// stateless functional components
// takes in properties and renders something
// purely an output of input
//const Jason = props => (
  //<div>Jason {props.name}!</div>
//)

// std def for react compoment
// this.props contains the properties passed to component invocation
// this.state is predfined name for where to store component state
class Jason extends Component {
  state = {
    count: 0,
    height: 10
  }

  componentDidMount = () => {
    console.log( this )
  }

  // fat arrow binds to context of this when its defined
  // which avoids needing to do
  // this.changeStuff.bind(this) below
  changeStuff = () => {
    this.setState({
      count: this.state.count + 1,
      height: this.state.height - 1
    })
  }

  render() {
    return (
      <div>
        <button onClick={this.changeStuff}>click me</button>
        <div>
          Jason {this.props.name}!
          count: {this.state.count}
          height: {this.state.height}
        </div>
      </div>
    )
  }
}

export default Jason
