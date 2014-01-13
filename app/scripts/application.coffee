JobModel = require "scripts/models/job"
JobCollection = require "scripts/collections/job"

ConcreteModel = require "scripts/models/concrete"
LaborModel = require "scripts/models/labor"
EquipmentModel = require "scripts/models/equipment"
MaterialModel = require "scripts/models/material"

ConcreteView = require "scripts/views/concrete"
LaborView = require "scripts/views/labor"
EquipmentView = require "scripts/views/equipment"
MaterialView = require "scripts/views/material"
CollectionView = require "scripts/views/collection"

AppRouter = require "scripts/router"

# Central Application object
class Application
    # Collection of jobs
    _jobs: null

    # Current job view
    _current: null

    # Initial view seeds
    _views:
        concrete: new ConcreteView
        labor: new LaborView
        materials: new MaterialView
        equipment: new EquipmentView

    # Initialize the data models and collections
    init: =>
        @_jobs = new JobCollection

        # Load the saved jobs
        @_jobs.fetch()

        # Populate the form with a blank job
        @create

        # Start routing
        Backbone.history.start()

        # Bind DOM events
        @_bindEvents()

        # Return
        @_jobs

    # Bind jQuery events
    _bindEvents: ->
        # Handle application events
        $(document).on "change", "input, select", @update

        # Select saved job list item
        $(".job-list").tap ->
            id = $(this).data "id"
            console.log "Job chosen has id of #{id}"
            app.read id
            true

        # Add job component buttons
        $(".add").tap ->
            type = $(this).data "type"
            console.log "Adding #{type} to active job"
            app.push type
            true

        # Save job button
        $(".job.save").tap @save

        # Save job button
        $(".job.reset").tap @delete

        true

    # Create new job
    create: =>
        @_current = new JobModel
        @_addComponent "concrete"
        @_addComponent "labor"
        @_addComponent "materials"
        @_addComponent "equipment"
        @_current

    # Load a saved job
    read: (cid) =>
        @_current = @_jobs.get cid
        @_current

    # Recalculate the loaded job
    update: =>
        @_current.calculate() if @_current?
        @_current

    # Delete the current job (and create a new empty one)
    delete: =>
        @_current.destroy()
        @create()
        true

    # Add the job to the saved collection
    save: =>
        if @_current.isValid()
            @_jobs.add @_current
            @_jobs.sync()
            true
        else
            alert @_current.validationError
            false

    # Validate a component before adding a new one to the job
    push: (type) =>
        last = @_current.get(type).last()

        if last.isValid()
            # Add to the job's collection for saving and calculating
            @update()
            @_addComponent type
        else
            alert last.validationError

        last

    # Create a new job component
    _addComponent: (type) ->
        # Model
        model = switch
            when type is "concrete" then new ConcreteModel
            when type is "labor" then new LaborModel
            when type is "materials" then new MaterialModel
            when type is "equipment" then new EquipmentModel

        @_views[type].addOne model
        @_current.get(type).push model
        true

module.exports = app = new Application
