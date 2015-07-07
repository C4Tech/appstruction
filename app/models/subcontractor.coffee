BaseModel = require "models/base"

module.exports = class SubcontractorModel extends BaseModel
  defaults:
    "scope_of_work": null
    "contractor_amount": null

  fields: [
      fieldType: "text"
      name: 'scope_of_work'
      label: 'Scope of Work'
      show: true
    ,
      fieldType: "number"
      name: "contractor_amount"
      label: 'Contractor Amount'
      show: true
  ]

  initialize: ->
    super

  calculate: ->
    scope_of_work = @attributes.scope_of_work ? ''
    @cost = @attributes.contractor_amount ? 0
    @cost = parseFloat(@cost)
    console.log "subcontractor row (#{scope_of_work}) ##{@cid}: cost #{@cost}"
    @cost

  overview: ->
    no_subcontractor = ['No subcontractor']
    scope_of_work = @attributes.scope_of_work ? ''
    contractor_amount = parseFloat(@attributes.contractor_amount) ? 0

    if isNaN(contractor_amount) or contractor_amount == 0
      return no_subcontractor

    subcontractor_item = "#{scope_of_work}: $#{contractor_amount.toFixed(2)}"

    return [
      subcontractor_item,
    ]
