Grid = ReactBootstrap.Grid

Decoration = require "layouts/header-decoration"
UserBar = require "layouts/user-bar"

module.exports = React.createClass
  render: ->
    <header>
      <UserBar />

      <div className="header-job-name">
        <Grid>
          <h3>{@state.job.name}</h3>
        </Grid>
      </div>

      <div className="header-title">
        <Grid>
          <h3>
            <span className="header-text">
              {@state.title}
            </span>

            <Decoration iconType="help" icon="question-circle" />
            <Decoration iconType="email" icon="envelope" />
            <Decoration iconType="pdf" icon="file-pdf-o" />
          </h3>
        </Grid>
      </div>
    </header>
