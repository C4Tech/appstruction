Input = ReactBootstrap.Input

module.exports = React.createClass
  getDefaultProps: ->
    {
      loaded: false
      parent: null
      items: null
      style: null
      help: null
    }

  render: ->
    <Loader loaded={@props.loaded}>
      <Input type="select"
             name="parent"
             defaultValue={@props.parent}
             bsStyle={@props.style}
             help={@props.help}>
        <option value="">Parent Business</option>
        {<option value={item.id}>{item.name}</option> for key, item of @props.items}
      </Input>
    </Loader>
