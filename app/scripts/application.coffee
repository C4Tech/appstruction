JobModel = require "scripts/models/job"

LaborView = require "scripts/views/labor"
EquipmentView = require "scripts/views/equipment"
MaterialView = require "scripts/views/material"

class Application
    _job: null

    _labor: null

    jobs: null

    init: ->
        @jobs = new JobCollection
        @jobs.fetch()
        @create()
        true

    create: ->
        @_job = new JobModel
            name: "Default"

    read: (cid) ->
        @_job = @jobs.get cid

    update: ->
        @_job.calculate()
        true

    delete: ->
        @_job.destroy()
        @create()

    save: ->
        @jobs.sync()

    saveJob: ->
        if @_job.isValid()
            @jobs.add @_job 
        else
            alert @_job.validationError
        
        @save()

    _createSub: (type) ->
        modelName = ucfirst(type) + "Model"
        viewName = ucfirst(type) + "View"
        variable = "_#{type}"
        @[variable] = new modelName

        new viewName
            model: @[variable]

        true

    addTo: (type) ->
        variable = "_#{type}"
        last = @[variable]
        if last.isValid()
            # Add to the job's collection for saving and calculating
            @_job.get(type).add last
            @update()
            @_createSub type
        else
            alert last.validationError 



module.exports = app = new Application

