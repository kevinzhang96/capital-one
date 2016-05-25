var HelloWorld = React.createClass({
  render: function render() {
    return <h1>Hello world!!!</h1>
  }
})

ReactDOM.render(
  <div>
    <HelloWorld/>
    <HelloWorld/>
    <HelloWorld/>
  </div>,
  document.getElementById('example')
)
