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
    options = @options
    id = payload.data.value ? grouping.length + 1
    options[payload.name].push
      value: "#{id}"
      label: "#{payload.data.label}"

    @setState
      options: options

    @saveToStorage()

    null

  getDefaultOptions: ->
    {
      concrete: [
          value: "1"
          label: "Sidewalk"
        ,
          value: "2"
          label: "Foundation"
        ,
          value: "3"
          label: "Curb"
        ,
          value: "4"
          label: "Footings"
        ,
          value: "5"
          label: "Driveway"
      ]
      equipment: [
          value: "1"
          label: "Dump Truck"
        ,
          value: "2"
          label: "Excavator"
        ,
          value: "3"
          label: "Bobcat"
        ,
          value: "4"
          label: "Concrete Pump"
        ,
          value: "5"
          label: "Concrete Saw"
        ,
          value: "6"
          label: "Piles"
        ,
          value: "7"
          label: "Trial"
        ,
          value: "8"
          label: "Util Truck"
        ,
          value: "9"
          label: "Trowel Machine"
      ]
      group: []
      job: [
          value: "1"
          label: "Municipal"
        ,
          value: "2"
          label: "Commercial"
        ,
          value: "3"
          label: "Residential"
        ,
          value: "4"
          label: "Civil"
        ,
          value: "5"
          label: "Structural"
      ]
      labor: [
          value: "1"
          label: "Finishers"
        ,
          value: "2"
          label: "Supervisors"
        ,
          value: "3"
          label: "Forms crp"
        ,
          value: "4"
          label: "Laborers"
        ,
          value: "5"
          label: "Driver"
        ,
          value: "6"
          label: "Operator"
        ,
          value: "7"
          label: "Carpenter"
        ,
          value: "8"
          label: "Ironworker"
      ]
      material: [
          value: "1"
          label: "Wire (sheet)"
        ,
          value: "2"
          label: "Keyway (lf)"
        ,
          value: "3"
          label: "Stakes (ea.)"
        ,
          value: "4"
          label: "Cap (lf)"
        ,
          value: "5"
          label: "Dowells  (ea.)"
        ,
          value: "6"
          label: "2x8x20  (lf)"
        ,
          value: "7"
          label: "Misc"
      ]
    }

module.exports = system.createStore ChoicesStore
