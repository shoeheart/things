import React from "react";
import PropTypes from "utils/propTypes";

import { Card, CardText, CardTitle } from "reactstrap";
import Typography from "../Typography";

const NumberWidget = ({ title, number, color, ...restProps }) => (
  <Card body {...restProps}>
    <div className="d-flex justify-content-between">
      <CardText tag="div">
        <Typography className="mb-0">
          <strong>{title}</strong>
        </Typography>
      </CardText>
      <CardTitle className={`text-${color}`}>{number}</CardTitle>
    </div>
  </Card>
);

NumberWidget.propTypes = {
  title: PropTypes.string.isRequired,
  number: PropTypes.oneOfType([
    PropTypes.string.isRequired,
    PropTypes.number.isRequired
  ]),
  color: PropTypes.oneOf([
    "primary",
    "secondary",
    "success",
    "info",
    "warning",
    "danger",
    "light",
    "dark"
  ]),
  progress: PropTypes.shape({
    value: PropTypes.number,
    label: PropTypes.string
  })
};

NumberWidget.defaultProps = {
  title: "",
  number: 0,
  color: "primary"
};

export default NumberWidget;
