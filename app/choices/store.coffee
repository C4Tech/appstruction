actions = require "choices/actions"
config = require "config"
LabelLookupClass = require "util/label-lookup"
system = require "system"

LabelLookup = new LabelLookupClass

class ChoicesStore
  constructor: ->
    @options = @readFromStorage()
    @bindActions actions
    @exportPublicMethods ->
      {
        getById: LabelLookup.getById,
        getLabelFor: LabelLookup.getLabelFor
      }
    null

  getById: LabelLookup.getById

  getStorageId: ->
    prefix = config.storagePrefix
    "#{prefix}-choices"

  saveToStorage: ->
    return unless window.localStorage?
    localStorage.setItem @getStorageId(), JSON.stringify @options

    null

  readFromStorage: ->
    return unless window.localStorage?
    data = JSON.parse localStorage.getItem @getStorageId()

    data or @getDefaultOptions()

  onCreate: (payload) ->
    payload.value ?= payload.label.toLowerCase()
    existing = @getById payload.type, payload.value
    return null if existing

    options = @options
    grouping = options[payload.type]
    options[payload.type].push
      value: "#{payload.value}"
      label: "#{payload.label}"

    @setState
      options: options

    null

  onSave: ->
    @saveToStorage()

    null

  getDefaultOptions: ->
    {
      concrete: [
          value: "sidewalk"
          label: "Sidewalk"
        ,
          value: "foundation"
          label: "Foundation"
        ,
          value: "curb"
          label: "Curb"
        ,
          value: "footings"
          label: "Footings"
        ,
          value: "driveway"
          label: "Driveway"
      ]
      equipment: [
          value: "dump truck"
          label: "Dump Truck"
        ,
          value: "excavator"
          label: "Excavator"
        ,
          value: "bobcat"
          label: "Bobcat"
        ,
          value: "concrete pump"
          label: "Concrete Pump"
        ,
          value: "concrete saw"
          label: "Concrete Saw"
        ,
          value: "piles"
          label: "Piles"
        ,
          value: "trial"
          label: "Trial"
        ,
          value: "util truck"
          label: "Util Truck"
        ,
          value: "trowel machine"
          label: "Trowel Machine"
      ]
      group: []
      job: [
          value: "municipal"
          label: "Municipal"
        ,
          value: "commercial"
          label: "Commercial"
        ,
          value: "residential"
          label: "Residential"
        ,
          value: "civil"
          label: "Civil"
        ,
          value: "structural"
          label: "Structural"
      ]
      labor: [
          value: "finishers"
          label: "Finishers"
        ,
          value: "supervisors"
          label: "Supervisors"
        ,
          value: "forms crp"
          label: "Forms crp"
        ,
          value: "laborers"
          label: "Laborers"
        ,
          value: "driver"
          label: "Driver"
        ,
          value: "operator"
          label: "Operator"
        ,
          value: "carpenter"
          label: "Carpenter"
        ,
          value: "ironworker"
          label: "Ironworker"
      ]
      material: [
          value: "wire (sheet)"
          label: "Wire (sheet)"
        ,
          value: "keyway (lf)"
          label: "Keyway (lf)"
        ,
          value: "stakes (ea.)"
          label: "Stakes (ea.)"
        ,
          value: "cap (lf)"
          label: "Cap (lf)"
        ,
          value: "dowells  (ea.)"
          label: "Dowells  (ea.)"
        ,
          value: "2x8x20  (lf)"
          label: "2x8x20  (lf)"
        ,
          value: "misc"
          label: "Misc"
      ]
    }

module.exports = system.createStore ChoicesStore
