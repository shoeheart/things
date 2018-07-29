import React from "react";
import { Table } from "reactstrap";

class AuditTrail extends React.Component {
  /* eslint class-methods-use-this: "error" */
  constructor(props) {
    super(props);
    this.state = {
      fieldHeaders: this.props.trail
        ? this.props.trail.fields.map(field => <th key={field}>{field}</th>)
        : [],
      fieldValues: this.props.trail
        ? this.props.trail.versions.map(version => (
            <tr key={version.version}>
              <td key="version">{version.version}</td>
              <td key="timestamp">{version.time}</td>
              <td key="responsible_id">{version.responsible_id}</td>
              {this.props.trail.fields.map(field => (
                <td key={field}>{version.changes[field]}</td>
              ))}
            </tr>
          ))
        : []
    };
  }

  render() {
    return (
      <Table striped>
        <thead>
          <tr>
            <th>Version</th>
            <th>Timestamp</th>
            <th>Responsible</th>
            {this.state.fieldHeaders}
          </tr>
        </thead>
        <tbody>{this.state.fieldValues}</tbody>
      </Table>
    );
  }
}

export default AuditTrail;
