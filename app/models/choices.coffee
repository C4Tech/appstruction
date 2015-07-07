# _ = require "underscore"
# Backbone = require "backbone"
# require "backbone.localStorage"

class ChoicesModel extends Backbone.Model
  localStorage: new Backbone.LocalStorage "cole-choices"
  url: "choices"

  defaults:
    concreteTypeOptions: [
        id: "1"
        text: "Sidewalk"
      ,
        id: "2"
        text: "Foundation"
      ,
        id: "3"
        text: "Curb"
      ,
        id: "4"
        text: "Footings"
      ,
        id: "5"
        text: "Driveway"
    ]

    concreteTypeOptionsDisplay:
      singular:
        "1": "sidewalk"
        "2": "foundation"
        "3": "curb"
        "4": "footing"
        "5": "driveway"
      plural:
        "1": "sidewalks"
        "2": "foundations"
        "3": "curbs"
        "4": "footings"
        "5": "driveways"

    equipmentTypeOptions: [
        id: "1"
        text: "Dump Truck"
      ,
        id: "2"
        text: "Excavator"
      ,
        id: "3"
        text: "Bobcat"
      ,
        id: "4"
        text: "Concrete pump"
      ,
        id: "5"
        text: "Concrete saw"
      ,
        id: "6"
        text: "Piles"
      ,
        id: "7"
        text: "Trial"
      ,
        id: "8"
        text: "Util Truck"
      ,
        id: "9"
        text: "Trowel machine"
    ]

    equipmentTypeOptionsDisplay:
      singular:
        "1": "dump truck"
        "2": "excavator"
        "3": "bobcat"
        "4": "concrete pump"
        "5": "concrete saw"
        "6": "pile"
        "7": "trial"
        "8": "util truck"
        "9": "trowel machine"
      plural:
        "1": "dump trucks"
        "2": "excavators"
        "3": "bobcats"
        "4": "concrete pumps"
        "5": "concrete saws"
        "6": "piles"
        "7": "trials"
        "8": "util trucks"
        "9": "trowel machines"

    groupNameOptions: []

    helpOptions:
      concrete: "Describe each concrete structure to be built"
      materials: "Describe all the material needed on the job"
      equipment: "List all equipment"
      dynamicDropdown: "If you don't see the option you want in the dropdown,
        start typing and it will be available in the future."

    jobGroups: []

    jobTypeOptions: [
        id: "1"
        text: "Municipal"
      ,
        id: "2"
        text: "Commercial"
      ,
        id: "3"
        text: "Residential"
      ,
        id: "4"
        text: "Civil"
      ,
        id: "5"
        text: "Structural"
    ]

    jobRoutes: [
      "concrete",
      "labor",
      "materials",
      "equipment",
      "subcontractor",
    ]

    laborTypeOptions: [
        id: "1"
        text: "Finishers"
      ,
        id: "2"
        text: "Supervisors"
      ,
        id: "3"
        text: "Forms crp"
      ,
        id: "4"
        text: "Laborers"
      ,
        id: "5"
        text: "Driver"
      ,
        id: "6"
        text: "Operator"
      ,
        id: "7"
        text: "Carpenter"
      ,
        id: "8"
        text: "Ironworker"
    ]

    laborTypeOptionsDisplay:
      singular:
        "1": "finisher",
        "2": "supervisor",
        "3": "forms crp",
        "4": "laborer",
        "5": "driver",
        "6": "operator",
      plural:
        "1": "finishers",
        "2": "supervisors",
        "3": "forms crp",
        "4": "laborers",
        "5": "drivers",
        "6": "operators",

    materialTypeOptions: [
        id: "1"
        text: "Wire (sheet)"
      ,
        id: "2"
        text: "Keyway (lf)"
      ,
        id: "3"
        text: "Stakes (ea.)"
      ,
        id: "4"
        text: "Cap (lf)"
      ,
        id: "5"
        text: "Dowells  (ea.)"
      ,
        id: "6"
        text: "2x8x20  (lf)"
      ,
        id: "7"
        text: "Misc"
    ]

    materialTypeOptionsDisplay:
      singular:
        "1": "wire"
        "2": "keyway"
        "3": "stake"
        "4": "cap"
        "5": "dowell"
        "6": "lf of 2x8x20"
        "7": "misc"
      plural:
        "1": "wire"
        "2": "keyways"
        "3": "stakes"
        "4": "caps"
        "5": "dowells"
        "6": "lf of 2x8x20"
        "7": "misc"

    measurementOptions: [
        id: "in"
        text: "Inches"
      ,
        id: "ft"
        text: "Feet"
      ,
        id:"yd"
        text: "Yards"
      ,
        id:"cm"
        text: "Centimeters"
      ,
        id:"m"
        text: "Meters"
    ]

    priceOptions: [
        id: "in"
        text: "Per Cubic Inch"
      ,
        id: "ft"
        text: "Per Cubic Foot"
      ,
        id: "yd"
        text: "Per Cubic Yard"
      ,
        id: "cm"
        text: "Per Cubic Centimeter"
      ,
        id: "m"
        text: "Per Cubic Meter"
    ]

    priceOptionsDisplay:
      singular:
        in: "cubic inch"
        ft: "cubic foot"
        yd: "cubic yard"
        cm: "cubic centimeter"
        m: "cubic meter"
      plural:
        in: "cubic inches"
        ft: "cubic feet"
        yd: "cubic yards"
        cm: "cubic centimeters"
        m: "cubic meters"

    timeOptions: [
        id: "hour"
        text: "Hours"
      ,
        id: "day"
        text: "Days"
      ,
        id: "week"
        text: "Weeks"
      ,
        id: "month"
        text: "Months"
    ]

    timeOptionsDisplay:
      singular:
        "hour": "hour"
        "day": "day"
        "week": "week"
        "month": "month"
      plural:
        "hour": "hours"
        "day": "days"
        "week": "weeks"
        "month": "months"

    timePerOptions: [
        id: "hour"
        text: "Hourly"
      ,
        id: "day"
        text: "Daily"
      ,
        id: "week"
        text: "Weekly"
      ,
        id: "month"
        text: "Monthly"
    ]

  getHelp: (key) ->
    helpOptions = @.get "helpOptions"
    helpOptions[key] if key of helpOptions

  getTextById: (optionsName, id) ->
    options = @get optionsName
    itemFound = item for item in options when item.id is id
    itemFound.text if itemFound?

  filterMatchId: (match) ->
    (item) ->
      item.id is match

  filterNotMatchId: (match) ->
    (item) ->
      item.id isnt match

  addJobGroup: (job) ->
    groupId = job.attributes.groupId
    groupNameOptions = @attributes.groupNameOptions
    jobGroups = @attributes.jobGroups

    groupOptions = item for item in groupNameOptions when item.id is groupId
    filteredJobGroups = item for item in jobGroups when item.group.id is groupId

    foundJob = false
    defaultJob =
      id: job.id
      name: job.attributes.job_name
    selectedGroup =
      group:
        id: groupOptions.id
        name: groupOptions.text
      jobs: []

    selectedGroup = filteredJobGroups if filteredJobGroups?
    selectedGroup.jobs = [] unless selectedGroup.jobs?

    foundJob = _.some selectedGroup.jobs, @filterMatchId job.id

    selectedGroup.jobs.push defaultJob unless foundJob
    @attributes.jobGroups.push selectedGroup unless filteredJobGroups?

    null

  removeJobGroup: (job) ->
    newJobGroups = []
    newJobGroups.push @filterJobs item, job for item in @attributes.jobGroups
    @attributes.jobGroups = newJobGroups

    null

  filterJobs: (jobGroup, job) ->
    jobs = jobGroup.jobs.filter @filterNotMatchId job.id
    retainedGroup =
      group: jobGroup.group
      jobs: jobs

    pruneJobGroups @filterMatchId job.attributes.groupId unless jobs.length

    retainedGroup if jobs.length

  pruneJobGroups: (filter) ->
    @attributes.groupNameOptions = _(@attributes.groupNameOptions).reject filter

    null

choices = new ChoicesModel
  id: 1
choices.fetch()
module.exports = choices
