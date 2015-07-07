BaseModel = require "models/base"

module.exports = class SubcontractorModel extends BaseModel
  defaults:
    scopeOfWork: null
    contractorAmount: null

  fields: [
      fieldType: "text"
      name: "scopeOfWork"
      label: "Scope of Work"
      show: true
    ,
      fieldType: "number"
      name: "contractorAmount"
      label: "Contractor Amount"
      show: true
  ]

  initialize: ->
    super

  calculate: ->
    @cost = parseFloat @attributes.contractorAmount or 0
    @cost = @cost.toFixed 2 if @numberValid @cost
    console.log "subcontractor row (#{@attributes.scopeOfWork}) ##{@cid}:
      cost #{@cost}"

    @cost

  overview: ->
    ["No subcontractor"] unless @numberValid @cost

    ["#{@attributes.scopeOfWork}: $#{@cost}"]
