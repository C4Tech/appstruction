JobModel = require "models/job"
Collection = require "models/collection"

PageView = require "views/page"
CollectionFormView = require "views/collection-form"
CollectionListView = require "views/collection-list"
JobElementFormView = require "views/job-element-form"
JobListView = require "views/job-list"
JobView = require "views/job"

module.exports = class Application extends Backbone.Router
    # Collection of jobs
    _jobs: null

    # Current job view
    _current: null

    _pages: {}

    _steps:
        type: "add.concrete"
        concrete: "add.labor"
        labor: "add.materials"
        materials: "add.equipment"
        equipment: "add.save"

    routes:
        "": "home"
        "home": "home"
        "open": "open"
        "browse": "browse"
        "read.:id": "read"
        "add(.:type)": "add"
        # "edit(.:type)": "edit"
        # "delete.:id": "delete"

    initialize: (opts) ->
        console.log "Initializing Cole"

        # Load the saved jobs
        @_jobs = new Collection null,
            model: JobModel
            type: "job"
            url: "jobs"

        @_jobs.fetch()

        # Populate the form with a blank job
        @_createJob()

        # Bind DOM events
        @_bindEvents()

        # Return
        @

    home: ->
        console.log "Loading home page"

        # Create the page only once
        unless @_pages["home"]?
            @_pages["home"] = new PageView
                id: "home"
                title: "Cole"
                text:
                    id: "start"
                    content: ""

            # Load the page
            @_setPage @_pages["home"]

        @_showPage @_pages["home"]

    browse: ->
        console.log "Loading browse page"

        # Create the page only once
        unless @_pages["browse"]
            @_pages["browse"] = new PageView
                id: "browse"
                title: "Load an Estimate"
                subView: new CollectionListView
                    title: "Saved Estimates"
                    type: "job"
                    collection: @_jobs
                    child: JobListView

            # Load the page
            @_setPage @_pages["browse"]

        @_showPage @_pages["browse"]

    read: (id) ->
        console.log "Loading job listing page"

        unless @_pages["read-#{id}"]?
            @_readJob id
            @_pages["read-#{id}"] = new PageView
                title: "Job overview"
                subView: new JobView
                    model: @_current

            @_setPage @_pages["read-#{id}"]

        @_showPage @_pages["read-#{id}"]

    add: (type = "type") ->
        console.log "Loading #{type} component page"

        # Create the page only once
        unless @_pages[type]?
            # Form component
            view = null
            collection = switch type
                when "concrete", "labor", "materials", "equipment" then @_current.get(type)
                else null

            if collection?
                console.log "Creating #{type} collection form view"
                view = new CollectionFormView
                    type: type
                    title: type
                    collection: collection
                    next: @_steps[type]
            else
                console.log "Creating job element form view"
                view = switch type
                    when "type", "save" then new JobElementFormView
                        type: type
                        title: type
                        model: @_current
                        next: @_steps[type]
                    else null

            # Create the page
            @_pages[type] = new PageView
                id: type
                title: "Job Builder"
                subView: view

            # Add the first component row
            @_addComponent type

            # Load the page
            @_setPage @_pages[type]

        @_showPage @_pages[type]

    # Tell jQuery Mobile to change the damn page
    _setPage: (page) ->
        $("body").append page.render().$el
        true

    _showPage: (page) ->
        $("section").hide()
        page.$el.show()
        true

    # Bind jQuery events
    _bindEvents: ->
        console.log "Binding events"

        # Bind URL clicks
        $(document).on "tap", "button.btn-primary, button.btn-link, button.job", (evt) ->
            evt.preventDefault()
            path = $(evt.currentTarget).data "path"
            Backbone.history.navigate path, true

        # Add job component buttons
        $(document).hammer().on "tap", "button.add", @_validateComponent

        # Save job button
        $(document).hammer().on "tap", "button.job.save", @_saveJob

        # Reset job button
        $(document).hammer().on "tap", "button.job.reset", @_deleteJob

        # Handle application events
        $(document).on "change", "input, select", @_updateCost

        true

    # Create new job
    _createJob: =>
        console.log "Creating new job"
        @_current = new JobModel
        @_current

    # Load a saved job
    _readJob: (cid) =>
        console.log "Reading job #{cid}"
        @_current = @_jobs.get cid
        @_current

    # Recalculate the loaded job
    _updateCost: =>
        console.log "Recalculating job cost"
        cost = @_current.calculate() if @_current?
        $('.job.cost').text cost
        @_current

    # Delete the current job (and create a new empty one)
    _deleteJob: =>
        console.log "Deleting job"
        @_current.destroy()
        @_createJob()
        true

    # Add the job to the saved collection
    _saveJob: (evt) =>
        console.log "Saving job"
        if @_current.isValid()
            @_current.save()
            @_jobs.add @_current
            console.log JSON.stringify @_current.toJSON()
            true
        else
            alert @_current.validationError
            false

    _addComponent: (type) =>
        # Model
        switch type
            when "concrete", "labor", "materials", "equipment" then @_current.get(type).add {}

        true

    # Validate a component before adding a new one to the job
    _validateComponent: (evt) =>
        evt.preventDefault()
        type = $(evt.currentTarget).data "type"
        console.log "Validating #{type}"
            # app._validateComponent type
            # (type) =>
        last = @_current.get(type).last()

        if last.isValid()
            # Add to the job's collection for saving and calculating
            console.log "Adding #{type} to active job"
            @_addComponent type
        else
            alert last.validationError

        last


module.exports = app = new Application
