Choices = require "models/choices"
JobModel = require "models/job"
JobCollection = require "models/job-collection"

PageView = require "views/page"
CollectionFormView = require "views/collection-form"
CollectionListView = require "views/collection-list"
JobElementFormView = require "views/job-element-form"
JobListView = require "views/job-list"
JobView = require "views/job"
BrowseView = require "views/browse"
DeleteBrowseView = require "views/delete-browse"
# Backbone = require "backbone"

module.exports = class Application extends Backbone.Router
  _jobs: null

  # Current job view
  _current: null

  _pages: null

  _steps:
    home:
      prev: "home"
    create:
      next: "add.concrete"
    concrete:
      prev: "add.create"
      next: "add.labor"
    labor:
      prev: "add.concrete"
      next: "add.materials"
    materials:
      prev: "add.labor"
      next: "add.equipment"
    equipment:
      prev: "add.materials"
      next: "add.subcontractor"
    subcontractor:
      prev: "add.equipment"
      next: "add.save"
    save:
      prev: "add.subcontractor"

  routes:
    "": "home"
    "home": "home"
    "open": "open"
    "browse": "browse"
    "delete-browse": "deleteBrowse"
    "read.:id": "read"
    "add(.:routeType)": "add"
    "edit(.:routeType)": "edit"
    "delete-job.:id": "deleteJob"
    "delete-group.:groupId": "deleteGroup"

  initialize: (opts) ->
    console.log "Initializing Appstruction"

    @_jobs = new JobCollection null,
      model: JobModel
      modelType: "job"
      url: "jobs"

    @_jobs.fetch()
    @_createJob()
    @_bindEvents()

    @

  home: ->
    console.log "Loading home page"
    @_createJob()
    @_pages = {}

    @setHomePage() unless @_pages["home"]?
    @_showPage @_pages["home"]

  setHomePage: ->
    @_pages["home"] = new PageView
      id: "home"
      title: "Concrete Estimator"
      text:
        id: "start"
        content: ""

    @_setPage @_pages["home"]
    null

  browse: ->
    console.log "Loading browse page"
    @setBrowsePage() unless @_pages["browse"]?
    @_showPage @_pages["browse"]

  setBrowsePage: ->
    @_pages["browse"] = new PageView
      id: "browse"
      title: "Load an Estimate"
      subView: new BrowseView
        routeType: "browse"

    @_setPage @_pages["browse"]
    null

  deleteBrowse: ->
    console.log "Loading delete-browse page"
    @setDeleteBrowsePage() unless @_pages["delete-browse"]?
    @_showPage @_pages["delete-browse"]

  setDeleteBrowsePage: ->
    @_pages["delete-browse"] = new PageView
      id: "delete-browse"
      title: "Delete an Estimate"
      subView: new DeleteBrowseView
        routeType: "delete-browse"

    @_setPage @_pages["delete-browse"]
    null

  read: (id) ->
    console.log "Loading job listing page"
    routeType = "read-#{id}"
    @setReadPage id, routeType unless @_pages[routeType]?
    @_showPage @_pages[routeType]

  setReadPage: (id, type) ->
    @_readJob id
    @_pages[type] = new PageView
      title: @_current.attributes.jobName
      subView: new JobView
        model: @_current
        routeType: "read"

    @_setPage @_pages[type]
    null

  add: (routeType = "create") ->
    console.log "Loading #{routeType} component page"
    @_viewJob routeType

  edit: (routeType = "create") ->
    console.log "Editing #{routeType} component page"
    @_viewJob routeType, "edit"

  deleteJob: (id, navigateHome = true) ->
    console.log "Deleting job"
    @_readJob id
    Choices.removeJobGroup @_current
    Choices.save()
    @_resetJob navigateHome

  deleteGroup: (groupId) ->
    console.log "Deleting group"
    groupModels = @_jobs.byGroupId groupId
    ids = _.pluck groupModels, "id"
    @deleteJob id, false for id in ids
    @_navigate "home"

  _setPage: (page) ->
    $("body").append page.render().$el
    true

  _showPage: (page) ->
    $("section").hide()
    page.$el.show()
    true

  _bindEvents: ->
    console.log "Binding events"

    $(document).hammer().on "tap", "button.ccma-navigate", @_navigateEvent
    $(document).hammer().on "tap", "button.ccma-navigate", @_updateHeader
    $(document).hammer().on "tap", "button.ccma-navigate", @_updateCost

    $(document).hammer().on "tap", "button.add", @_validateComponent
    $(document).hammer().on "tap", "button.job.save", @_saveJob
    $(document).hammer().on "tap", "button.job.reset", @_resetJob

    $(document).hammer().on "tap", ".field-help", @_showHelp

    $(document).hammer().on "tap", ".header-help", @_showHelp
    $(document).hammer().on "tap", ".header-email", @_promptEmail
    $(document).hammer().on "tap", ".header-pdf", @_promptPdf

    $(document).hammer().on "change", ".field", @_updateCost

    true

  _navigateEvent: (event) ->
    event.preventDefault()
    path = $(event.currentTarget).data "path"
    Backbone.history.navigate path, true
    $("nav button").removeClass "active"
    pathNav = path.split ".", 1
    $("nav button.#{pathNav}").addClass "active"

  _navigate: (path) ->
    Backbone.history.navigate path, true
    $("nav button").removeClass "active"
    pathNav = path.split ".", 1
    $("nav button.#{pathNav}").addClass "active"

  _createJob: =>
    console.log "Creating new job"
    @_current = new JobModel
    @_current

  _readJob: (id) =>
    console.log "Reading job #{id}"
    @_current = @_jobs.get id
    @_current

  _viewJob: (routeType = "create", viewType = "add") =>
    console.log "Viewing job"
    @setJobPage routeType, viewType unless @_pages[routeType]?
    @_showPage @_pages[routeType]

  setJobPage: (type, viewType) ->
    collection = @_current.get type if type in Choices.get "job_routes"

    view = createJobCollectionPage collection, type if collection?
    view ?= @createJobElementPage type

    @_pages[routeType] = new PageView
      id: type
      title: "Job Builder"
      subView: view

    @_addComponent type if viewType is "add"
    @_setPage @_pages[type]

    null

  createJobCollectionPage: (collection, type) ->
    console.log "Creating #{routeType} collection form view"
    new CollectionFormView
      title: type
      routeType: type
      collection: collection
      step: @_steps[type]

  createJobElementPage: (type) ->
    console.log "Creating job element form view"
    null unless type in ["create", "save"]
    new JobElementFormView
      title: type
      routeType: type
      model: @_current
      step: @_steps[type]

  _updateCost: =>
    console.log "Recalculating job cost"
    cost = @_current.calculate() if @_current?
    $(".subtotal").text cost.toFixed 2
    @_current

  _updateHeader: (currentRoute = null) =>
    console.log "Refreshing header"

    # When called from an event, the event object is passed as parameter.
    # In that scenario we want currentRoute to be null at this point.
    if typeof currentRoute isnt "string"
      event = currentRoute
      currentRoute = null

    currentRoute ?= Backbone.history.fragment
    null unless currentRoute?

    headerTitle = $("div.header-title").find "h3"
    headerEmail = headerTitle.find ".header-email"
    headerPdf = headerTitle.find ".header-pdf"

    routeType = currentRoute.split "."
    routeType = routeType[routeType.length - 1]

    @setPageHeader headerTitle, currentRoute, routeType
    @setPageHelp headerTitle, routeType

    headerEmail.hide()
    headerPdf.hide()
    if currentRoute is "add.save"
      headerEmail.show()
      headerPdf.show()

    @_current

  setPageHeader: (title, route, type) ->
    allowedRoutes = [
      "add.concrete"
      "add.labor"
      "add.materials"
      "add.equipment"
      "add.subcontractor"
      "add.save"
      "edit.concrete"
      "edit.labor"
      "edit.materials"
      "edit.equipment"
      "edit.subcontractor"
    ]

    headerJobName = $ "div.header-job-name"
    headerJobName.hide()

    null unless route[0..3] is "read" and route not in allowedRoutes

    jobName.find("h3").text @_current.attributes.jobName
    jobName.show()

    headerText = title.find ".header-text"
    headerText.text type if type in Choices.get "jobRoutes"
    null

  setPageHelp: (title, type) ->
    headerHelp = title.find ".header-help"

    help = Choices.getHelp type
    headerHelp.hide()

    null unless help?

    headerHelp.data "help", help
    headerHelp.show()
    null

  _showHelp: (event) ->
    bootbox.alert $(event.currentTarget).data "help"

  _generatePromptBody: =>
    a = @_current.attributes
    jobType = Choices.getTextById "jobTypeOptions", a.jobType
    groupName = Choices.getTextById "groupNameOptions", a.groupId

    cost = @_current.cost
    totalCost = cost
    profitMargin = 0

    unless isNaN(parseFloat(a.profitMargin)) and isFinite a.profitMargin
      profitMargin = a.profitMargin
      totalCost += totalCost * (a.profitMargin / 100)

    concrete = ""
    concrete += @joinText item for item in a.concrete.models

    labor = ""
    labor += @joinText item for item in a.labor.models

    materials = ""
    materials += @joinText item for item in a.materials.models

    equipment = ""
    equipment += @joinText item for item in a.equipment.models

    subcontractor = ""
    subcontractor += @joinText item for item in a.subcontractor.models

    """
      Group: #{groupName}
      Job name: #{a.jobName}
      Job type: #{jobType}

      Subtotal: #{cost.toFixed(2)}
      Profit margin: #{profitMargin}%
      Cost: #{totalCost.toFixed(2)}

      Concrete:
      #{concrete}
      Labor:
      #{labor}
      Materials:
      #{materials}
      Equipment:
      #{equipment}
      Subcontractor:
      #{subcontractor}
    """

  joinText: (item) ->
    itemText = item.overview().join "\n"
    "#{itemText}\n\n"

  _promptPdf: (event) =>
    filename = "#{@_current.attributes.jobName}.pdf"
    body = @_generatePromptBody()

    doc = new jsPDF()

    doc.setFontSize 22
    doc.setFontType "bold"
    doc.text 20, 20, "Appstruction Proposal"

    doc.setFontSize 14
    doc.setFontType "normal"
    doc.text 20, 30, body

    doc.save filename

  _promptEmail: (event) =>
    subject = "Appstruction proposal"
    body = @_generatePromptBody()
    body = encodeURIComponent body
    window.location.href = "mailto:?subject=#{subject}&body=#{body}";

  _resetJob: =>
    console.log "Reseting job"
    @_current.destroy()
    @_navigate "home"
    true

  _saveJob: (event) =>
    console.log "Saving job"

    unless @_current.isValid()
      alert @_current.validationError
      false

    @_current.save()
    Choices.addJobGroup @_current
    Choices.save()
    @_jobs.add @_current
    console.log JSON.stringify @_current.toJSON()
    true

  _addComponent: (routeType) =>
    @_current.get(routeType).add {} if routeType in Choices.get "jobRoutes"

    $("select").select2
      allowClear: true
      minimumResultsForSearch: 6

    $("input[type=number]").keyup (event) ->
      val = $(event.currentTarget).val()

      if val.lastIndexOf(".", 0) is 0
        template = ".0000000000"
        null if val is template.substring 0, val.length
        $(event.currentTarget).val "0#{val}"

    null

  _validateComponent: (event) =>
    event.preventDefault()
    routeType = $(event.currentTarget).data "type"
    console.log "Validating #{routeType}"

    last = @_current.get(routeType).last()
    unless last.isValid()
      alert last.validationError
      null

    console.log "Adding #{routeType} to active job"
    @_addComponent routeType
    last
