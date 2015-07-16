RouteHandler = ReactRouter.RouteHandler

module.exports = React.createClass
  render: ->
    <div>
      <h3>{@state.job.name}</h3>

      <div className="header-title">
        <h3>
          {@state.title}

          <Decoration iconType="help" icon="question-circle" />
          <Decoration iconType="email" icon="envelope" />
          <Decoration iconType="pdf" icon="file-pdf-o" />
        </h3>
      </div>

      <RouteHandler />
    </div>
