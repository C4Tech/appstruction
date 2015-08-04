module.exports = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    size: React.PropTypes.oneOf [
      "lg",
      "2x",
      "3x",
      "4x",
      "5x"
    ]
    rotate: React.PropTypes.oneOf [
      "45",
      "90",
      "135",
      "180",
      "225",
      "270",
      "315"
    ]
    flip: React.PropTypes.oneOf ["horizontal", "vertical"]
    pull: React.PropTypes.oneOf ["left", "right"]
    fixedWidth: React.PropTypes.bool
    spin: React.PropTypes.bool
    stack: React.PropTypes.oneOf ["1x", "2x"]
    inverse: React.PropTypes.bool
    className: React.PropTypes.string

  render: ->
    classNames = "fa fa-#{@props.name}"
    classNames += " fa-#{@props.size}" if @props.size
    classNames += " fa-rotate-#{@props.rotate}" if @props.rotate
    classNames += " fa-flip-#{@props.flip}" if @props.flip
    classNames += " fa-fw"  if @props.fixedWidth
    classNames += " fa-spin"  if @props.spin
    classNames += " fa-stack-#{@props.stack}" if @props.stack
    classNames += " fa-pull-#{@props.pull}" if @props.pull
    classNames += " fa-inverse" if @props.inverse
    classNames += " #{@props.className}"  if @props.className

    <span {...@props} className={classNames} />
