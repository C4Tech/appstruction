PropTypes = React.PropTypes

module.exports = React.createClass
  propTypes:
    name: PropTypes.string.isRequired
    size: PropTypes.oneOf ["lg", "2x", "3x", "4x", "5x"]
    rotate: PropTypes.oneOf ["45", "90", "135", "180", "225", "270", "315"]
    flip: PropTypes.oneOf ["horizontal", "vertical"]
    fixedWidth: PropTypes.bool
    spin: PropTypes.bool
    stack: React.PropTypes.oneOf ["1x", "2x"]
    inverse: React.PropTypes.bool

  render: ->
    classNames = "fa fa-#{@props.name}";
    classNames += " fa-#{@props.size}" if @props.size
    classNames += " fa-rotate-#{@props.rotate}" if @props.rotate
    classNames += " fa-flip-#{@props.flip}" if @props.flip
    classNames += " fa-fw"  if @props.fixedWidth
    classNames += " fa-spin"  if @props.spin
    classNames += " fa-stack-#{@props.stack}" if @props.stack
    classNames += " fa-inverse" if @props.inverse
    classNames += " #{@props.className}"  if @props.className

    <span {...@props} className={classNames} />
