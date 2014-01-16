JobModel = require "models/job"
JobCollection = require "collections/job"

ConcreteModel = require "models/concrete"
LaborModel = require "models/labor"
EquipmentModel = require "models/equipment"
MaterialModel = require "models/material"

PageView = require "views/page"
FormView = require "views/form"
TypeView = require "views/type"
JobView = require "views/job"


module.exports = class Application extends Backbone.Router
    # Collection of jobs
    _jobs: null

    # Current job view
    _current: null

    _pages: {}

    _steps:
        type: "create/concrete"
        concrete: "create/labor"
        labor: "create/materials"
        materials: "create/equipment"
        equipment: "create/job"

    routes:
        "": "home"
        "home": "home"
        "open": "open"
        "create(/:component)": "create"

    initialize: (opts) ->
        console.log "Initializing Cole"

        # Load the saved jobs
        @_jobs = new JobCollection
        @_jobs.fetch()

        # Populate the form with a blank job
        @_createJob()

        # Bind DOM events
        @_bindEvents()

        # Return
        @

    home: ->
        console.log "Loading home page"
        page = new PageView
            id: "home"
            title: "Cole"
            links: [
                    url: "create"
                    text: "Create new estimate"
                ,
                    url:"open"
                    text: "Load estimate"
            ]
            article:
                id: "start"
                content: ""
        $("body").append @$el
        $.mobile.changePage page.$el, {changeHash: false}
        true

    create: (component = "type") ->
        console.log "Loading #{component} component page"

        # Create the page only once
        if not @_pages[type]?
            # Form component
            view = null
            collection = switch type
                when "concrete", "labor", "materials", "equipment" then @_current.get(type)
                else null

            if collection
                view = new CollectionFormView
                    type: type
                    title: type
                    collection: collection
                    next: @_steps[type]

            # Create the page
            @_pages[type] = new PageView
                id: type
                title: "Job Builder"
                back:
                    url: "home"
                    title: "Home"
                content: view

            $("body").append @$el
            # Add the first component row
            @_addComponent component

        # Tell jQuery Mobile to change the damn page
        $.mobile.changePage @_pages[component].$el, {changeHash: false}
        true

    open: ->
        console.log "Loading job listing page"
        page = new PageView
            title: "Load an estimate"
            back:
                url: "home"
                title: "Home"

        $("body").append @$el
        jobOpen = require "templates/job-open"
        $(".page").append jobOpen()
        $.mobile.changePage page.$el, {changeHash: false}

        # @todo: Add list
        true

    # Bind jQuery events
    _bindEvents: ->
        console.log "Binding events"

        # Kill jQuery mobile navigation
        $(document).on "mobileinit", ->
            $.mobile.ajaxEnabled = false
            $.mobile.linkBindingEnabled = false
            $.mobile.hashListeningEnabled = false
            $.mobile.pushStateEnabled = false
            $.mobile.ignoreContentEnabled = true

            $('div[data-role="page"]').on 'pagehide', (event, ui) ->
                $(event.currentTarget).remove()

        # Bind URL clicks
        $(document).on "tap", "a:not([data-bypass])", (evt) ->
            evt.preventDefault()
            path = $(this).attr "href"
            Backbone.history.navigate path, true
  
        # Handle application events
        $(document).on "change", "input, select", @_updateCost

        $(document).on "change", "select.type", (event) ->
            target = $ event.currentTarget
            app._current.set "type", target.val()
            console.log "View changed target to #{target.val()}"
            true

        # Select saved job list item
        $(document).on "tap", "a.job-list", (evt) ->
            id = $(this).data "id"
            console.log "Job chosen has id of #{id}"
            app._readJob id
            true

        # Add job component buttons
        $(document).on "tap", "button.add", (evt) ->
            evt.preventDefault()
            type = $(this).data "type"
            console.log "Validating #{type}"
            app._validateComponent type

        # Save job button
        $(document).on "tap", ".job.save", @_saveJob

        # Save job button
        $(document).on "tap", ".job.reset", @_deleteJob

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
    _saveJob: =>
        console.log "Saving job"
        if @_current.isValid()
            @_jobs.add @_current
            @_jobs.sync()
            true
        else
            alert @_current.validationError
            false

    _addComponent: (type) ->
        # Model
        model = switch
            when type is "concrete" then new ConcreteModel
            when type is "labor" then new LaborModel
            when type is "materials" then new MaterialModel
            when type is "equipment" then new EquipmentModel
            when type is "job" then @_current
            else {}

        if model.attributes? and type isnt "job"
            @_current.get(type).push model
        true

    # Validate a component before adding a new one to the job
    _validateComponent: (type) =>
        last = @_current.get(type).last()

        if last.isValid()
            # Add to the job's collection for saving and calculating
            console.log "Adding #{type} to active job"
            @_addComponent type
        else
            alert last.validationError

        last


module.exports = app = new Application
