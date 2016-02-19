Wrapper = require "forms/input-wrapper"
Input = ReactBootstrap.Input

module.exports = React.createClass
  getDefaultProps: ->
    {
      isVertical: true
    }

  render: ->
    type = @props.type ? "text"

    output = <Input {...@props} type={type} />

    return output unless @props.isVertical

    <Wrapper>
      {output}
    </Wrapper>
