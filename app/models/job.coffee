BaseModel = require "models/base"
Choices = require "models/choices"
ConcreteModel = require "models/concrete"
EquipmentModel = require "models/equipment"
JobCollection = require "models/job-collection"
LaborModel = require "models/labor"
MaterialModel = require "models/material"
SubcontractorModel = require "models/subcontractor"
# Backbone = require "backbone"

module.exports = class JobModel extends BaseModel
  localStorage: new Backbone.LocalStorage "cole-job"
  url: "jobs"
  cid: null

  fields: [
      fieldType: "hidden"
      name: "groupId"
      label: "Group Name"
      optionsType: "groupNameOptions"
      show: true
      append: "<br />"
    ,
      fieldType: "text"
      name: "jobName"
      label: "Job Name"
      show: true
    ,
      fieldType: "hidden"
      name: "jobType"
      label: "What type of job"
      optionsType: "jobTypeOptions"
      show: true
      append: "<br />"
      fieldHelp: true
      fieldHelpValue: Choices.getHelp "dynamicDropdown"
    ,
      fieldType: "number"
      name: "profitMargin"
      label: "Profit Margin"
      show: false
      required: false
      overview: true
  ]

  initialize: ->
    @attributes.cid = @cid
    super

  defaults: ->
    data =
      jobName: null
      profitMargin: null
      jobType: null
      groupId: null

    @parse data

  parse: (data) ->
    types = Choices.get "jobRoutes"
    data[type] = @inflate type, data[type] for type in types
    data

  inflate: (type, data) ->
    model = switch type
      when "concrete" then ConcreteModel
      when "labor" then LaborModel
      when "materials" then MaterialModel
      when "equipment" then EquipmentModel
      when "subcontractor" then SubcontractorModel

    new JobCollection data,
      model: model
      modelType: type

  calculate: ->
    @cost = @attributes.concrete.calculate()
    @cost += @attributes.labor.calculate()
    @cost += @attributes.materials.calculate()
    @cost += @attributes.equipment.calculate()
    @cost += @attributes.subcontractor.calculate()

    log.trace "Job total: #{@attributes.concrete.cost} +
      #{@attributes.labor.cost} + #{@attributes.materials.cost} +
      #{@attributes.equipment.cost} + #{@attributes.subcontractor.cost}
      = #{@cost}"

    @cost
