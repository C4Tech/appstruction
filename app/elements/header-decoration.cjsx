Icon = ReactFA.Icon

module.exports = React.createClass
  render: ->
    <span {..@props}
        className="header-#{props.iconType} pull-right">
      <Icon name={@props.icon} />
    </span>
