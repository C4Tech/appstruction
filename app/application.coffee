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

    _jobRoutes: null

    _steps:
        home:
            prev: "home"
        create:
            next: "add.concrete"
        concrete:
            prev: "add.create"
            next: "add.labor"
        labor:
            prev: "add.concrete"
            next: "add.materials"
        materials:
            prev: "add.labor"
            next: "add.equipment"
        equipment:
            prev: "add.materials"
            next: "add.save"
        save:
            prev: "add.equipment"

    routes:
        "": "home"
        "home": "home"
        "open": "open"
        "browse": "browse"
        "read.:id": "read"
        "add(.:routeType)": "add"
        # "edit(.:routeType)": "edit"
        # "delete.:id": "delete"

    initialize: (opts) ->
        console.log "Initializing Cole"

        temp = new JobModel
        @_jobRoutes = temp.jobRoutes

        # Load the saved jobs
        @_jobs = new Collection null,
            model: JobModel
            modelType: "job"
            jobRoutes: @_jobRoutes
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

        # Create new (empty) job
        @_createJob()

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
                    modelType: 'job'
                    routeType: 'browse'
                    collection: @_jobs
                    child: JobListView
                    step: @_steps['home']

            # Load the page
            @_setPage @_pages["browse"]

        @_showPage @_pages["browse"]

    read: (id) ->
        console.log "Loading job listing page"
        routeType = "read-#{id}"
        unless @_pages[routeType]?
            @_readJob id
            @_pages[routeType] = new PageView
                title: @_current.attributes.name
                subView: new JobView
                    model: @_current
                    jobRoutes: @_jobRoutes
                    routeType: 'read'

            @_setPage @_pages[routeType]
        @_showPage @_pages[routeType]

    add: (routeType = "create") ->
        console.log "Loading #{routeType} component page"
        @_viewJob(routeType)

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
        $(document).on "tap", "button.ccma-navigate", @_navigate
        $(document).on "tap", "button.ccma-navigate", @_updateJobName
        $(document).on "tap", "button.ccma-navigate", @_updateCost

        # Add job component buttons
        $(document).hammer().on "tap", "button.add", @_validateComponent

        # Save job button
        $(document).hammer().on "tap", "button.job.save", @_saveJob

        # Reset job button
        $(document).hammer().on "tap", "button.job.reset", @_deleteJob

        # Handle application events
        $(document).on "change", ".field", @_updateCost

        true

    # Handle navigation
    _navigate: (evt) ->
        evt.preventDefault()
        path = $(evt.currentTarget).data "path"
        Backbone.history.navigate path, true
        $("nav button").removeClass "active"
        pathNav = path.split ".", 1
        $("nav button.#{pathNav}").addClass "active"

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

    # View the current job
    _viewJob: (routeType = "create") =>
        console.log "Viewing job"
        # Create the page only once
        unless @_pages[routeType]?
            # Form component
            view = null
            collection = null

            if routeType in @_jobRoutes
                collection = @_current.get(routeType)

            if collection?
                console.log "Creating #{routeType} collection form view"
                view = new CollectionFormView
                    title: routeType
                    routeType: routeType
                    collection: collection
                    step: @_steps[routeType]
            else
                console.log "Creating job element form view"
                if routeType in ['create', 'save']
                    view = new JobElementFormView
                        title: routeType
                        routeType: routeType
                        model: @_current
                        jobRoutes: @_jobRoutes
                        step: @_steps[routeType]

            # Create the page
            @_pages[routeType] = new PageView
                id: routeType
                title: "Job Builder"
                subView: view

            # Add the first component row
            @_addComponent routeType

            # Load the page
            @_setPage @_pages[routeType]

        @_showPage @_pages[routeType]

    # Recalculate the loaded job
    _updateCost: =>
        console.log "Recalculating job cost"
        cost = @_current.calculate() if @_current?
        $('.subtotal').text cost.toFixed(2)
        @_current

    # Refresh the displayed job name
    _updateJobName: (currentRoute = null) =>
        console.log "Refreshing job name"

        # When called from an event, the event object is passed as parameter.
        # In that scenario we want currentRoute to be null at this point.
        if typeof currentRoute != 'string'
            currentRoute = null

        currentRoute = currentRoute || Backbone.history.fragment
        return if not currentRoute?

        allowedRoutes = [
            "add.concrete"
            "add.labor"
            "add.materials"
            "add.equipment"
            "add.save"
        ]

        headerJobName = $('.header-job-name')
        if currentRoute[0..3] == 'read' or currentRoute in allowedRoutes
            headerJobName.find('h1').text @_current.attributes.name
            headerJobName.show()
        else
            headerJobName.hide()
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

    _addComponent: (routeType) =>
        # Model
        if routeType in @_jobRoutes
            @_current.get(routeType).add {}

        true

    # Validate a component before adding a new one to the job
    _validateComponent: (evt) =>
        evt.preventDefault()
        routeType = $(evt.currentTarget).data 'type'
        console.log "Validating #{routeType}"

        last = @_current.get(routeType).last()
        if last.isValid()
            # Add to the job's collection for saving and calculating
            console.log "Adding #{routeType} to active job"
            @_addComponent routeType
        else
            alert last.validationError

        last


module.exports = app = new Application
