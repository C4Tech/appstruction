BaseModel = require "models/base"
LaborModel = require "models/labor"
ConcreteModel = require "models/concrete"
MaterialModel = require "models/material"
EquipmentModel = require "models/equipment"
JobCollection = require "models/job-collection"

module.exports = class JobModel extends BaseModel
    localStorage: new Backbone.LocalStorage "cole-job"
    url: "jobs"
    jobRoutes: ['concrete', 'labor', 'materials', 'equipment']

    job_type_options: [
            id: "1"
            text: "Slab"
        ,
            id: "2"
            text: "GB- H"
        ,
            id:"3"
            text: "GB - H1A"
        ,
            id:"4"
            text: "GB - V"
        ,
            id:"5"
            text: "Piles"
        ,
            id:"6"
            text: "Truck Well"
    ]

    group_name_options: [
            id: "1"
            text: "G1"
        ,
            id: "2"
            text: "G2"
        ,
            id:"3"
            text: "G3"
    ]

    fields: [
            name: 'group_name'
            fieldType: 'select'
            label: 'Group Name'
            fieldTypeSelect: true
            optionsType: 'group_name'
            show: true
        ,
            name: "job_name"
            placeholder: "Job Name"
            fieldType: "text"
            label: 'Job Name'
            show: true
        ,
            name: "job_type"
            placeholder: "What type of job"
            fieldType: "select"
            label: 'Select a job type'
            fieldTypeSelect: true
            optionsType: 'job_type'
            show: true
        ,
            name: "profit_margin"
            placeholder: "Profit Margin"
            fieldType: "number"
            show: false
    ]

    initialize: ->
        self = @
        _(@fields).each (field) =>
            field.options = self.job_type_options if field.optionsType == 'job_type'
            field.options = self.group_name_options if field.optionsType == 'group_name'

    defaults: ->
        data =
            name: null
            margin: null
            job_type: null

        @parse data

    parse: (data) ->
        for collection in @jobRoutes
            saved = if data[collection]? then data[collection] else false
            data[collection] = @_inflateCollection collection, saved
        data

    _inflateCollection: (modelType, data) ->
        model = switch modelType
            when "concrete" then ConcreteModel
            when "labor" then LaborModel
            when "materials" then MaterialModel
            when "equipment" then EquipmentModel
        new JobCollection data, {
                model: model
                modelType: modelType
            }

    calculate: ->
        @cost = @attributes.concrete.calculate() + @attributes.labor.calculate() + @attributes.materials.calculate() + @attributes.equipment.calculate()

        if @cost
            console.log "Job total: #{@attributes.equipment.cost} + #{@attributes.concrete.cost} + #{@attributes.labor.cost} + #{@attributes.materials.cost} = #{@cost}"
        @cost
