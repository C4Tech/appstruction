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
  jobs: null

  # Current job view
  current: null

  pages: null

  steps:
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

    @jobs = new JobCollection null,
      model: JobModel
      modelType: "job"
      url: "jobs"

    @jobs.fetch()
    @createJob()
    @bindEvents()

    console.log "Finished initialization"

    @

  bindEvents: ->
    console.log "Binding events"

    $(document.body).hammer().on "tap", "button.ccma-navigate", @navigateEvent
    $(document.body).hammer().on "tap", "button.ccma-navigate", @updateHeader
    $(document.body).hammer().on "tap", "button.ccma-navigate", @updateCost

    $(document.body).hammer().on "tap", "button.add", @validateComponent
    $(document.body).hammer().on "tap", "button.job.save", @saveJob
    $(document.body).hammer().on "tap", "button.job.reset", @resetJob

    $(document.body).hammer().on "tap", ".field-help", @showHelp

    $(document.body).hammer().on "tap", ".header-help", @showHelp
    $(document.body).hammer().on "tap", ".header-email", @promptEmail
    $(document.body).hammer().on "tap", ".header-pdf", @promptPdf

    $(document.body).hammer().on "change", ".field", @updateCost

    console.log "Finished binding events"
    true

  createJob: =>
    console.log "Creating new job"
    @current = new JobModel
    @current

  readJob: (id) =>
    console.log "Reading job #{id}"
    @current = @jobs.get id
    @current

  home: ->
    console.log "Loading home page"
    @createJob()
    @pages = {}

    @createHomePage() unless @pages["home"]?
    @showPage @pages["home"]

  createHomePage: ->
    @pages["home"] = new PageView
      id: "home"
      title: "Concrete Estimator"
      text:
        id: "start"
        content: ""

    @setPage @pages["home"]
    null

  browse: ->
    console.log "Loading browse page"
    @createBrowsePage() unless @pages["browse"]?
    @showPage @pages["browse"]

  createBrowsePage: ->
    @pages["browse"] = new PageView
      id: "browse"
      title: "Load an Estimate"
      subView: new BrowseView
        routeType: "browse"

    @setPage @pages["browse"]
    null

  deleteBrowse: ->
    console.log "Loading delete-browse page"
    @createDeleteBrowsePage() unless @pages["delete-browse"]?
    @showPage @pages["delete-browse"]

  createDeleteBrowsePage: ->
    @pages["delete-browse"] = new PageView
      id: "delete-browse"
      title: "Delete an Estimate"
      subView: new DeleteBrowseView
        routeType: "delete-browse"

    @setPage @pages["delete-browse"]
    null

  read: (id) ->
    console.log "Loading job listing page"
    routeType = "read-#{id}"
    @createReadPage id, routeType unless @pages[routeType]?
    @showPage @pages[routeType]

  createReadPage: (id, type) ->
    @readJob id
    @pages[type] = new PageView
      title: @current.attributes.jobName
      subView: new JobView
        model: @current
        routeType: "read"

    @setPage @pages[type]
    null

  add: (routeType = "create") ->
    console.log "Loading #{routeType} component page"
    @viewJob routeType

  edit: (routeType = "create") ->
    console.log "Editing #{routeType} component page"
    @viewJob routeType, "edit"

  deleteJob: (id, navigateHome = true) ->
    console.log "Deleting job"
    @readJob id
    Choices.removeJobGroup @current
    Choices.save()
    @resetJob navigateHome

  deleteGroup: (groupId) ->
    console.log "Deleting group"
    groupModels = @jobs.byGroupId groupId
    ids = _.pluck groupModels, "id"
    @deleteJob id, false for id in ids
    @navigate "home"

  setPage: (page) ->
    $(document.body).append page.render().$el
    true

  showPage: (page) ->
    $("section").hide()
    page.$el.show()
    true

  navigateEvent: (event) =>
    event.preventDefault()
    console.log "Navigation triggered on", event.currentTarget
    path = $(event.currentTarget).data "path"
    @navigate path

  navigate: (path) ->
    Backbone.history.navigate path, true
    $("nav button").removeClass "active"
    pathNav = path.split ".", 1
    $("nav button.#{pathNav}").addClass "active"

  viewJob: (routeType = "create", viewType = "add") =>
    console.log "Viewing job"
    @createJobPage routeType, viewType unless @pages[routeType]?
    @showPage @pages[routeType]

  createJobPage: (type, viewType) ->
    collection = @current.get type if type in Choices.get "jobRoutes"

    view = createJobCollectionPage collection, type if collection?
    view ?= @createJobElementPage type

    @pages[type] = new PageView
      id: type
      title: "Job Builder"
      subView: view

    @addComponent type if viewType is "add"
    @setPage @pages[type]

    null

  createJobCollectionPage: (collection, type) ->
    console.log "Creating #{routeType} collection form view"
    new CollectionFormView
      title: type
      routeType: type
      collection: collection
      step: @steps[type]

  createJobElementPage: (type) ->
    console.log "Creating job element form view"
    null unless type in ["create", "save"]
    new JobElementFormView
      title: type
      routeType: type
      model: @current
      step: @steps[type]

  updateCost: =>
    console.log "Recalculating job cost"
    cost = @current.calculate() if @current?
    $(".subtotal").text cost.toFixed 2
    @current

  updateHeader: (currentRoute = null) =>
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

    @current

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

    jobName.find("h3").text @current.attributes.jobName
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

  showHelp: (event) ->
    bootbox.alert $(event.currentTarget).data "help"

  generatePromptBody: =>
    a = @current.attributes
    jobType = Choices.getTextById "jobTypeOptions", a.jobType
    groupName = Choices.getTextById "groupNameOptions", a.groupId

    cost = @current.cost
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

  promptPdf: (event) =>
    filename = "#{@current.attributes.jobName}.pdf"
    body = @generatePromptBody()

    doc = new jsPDF()

    doc.setFontSize 22
    doc.setFontType "bold"
    doc.text 20, 20, "Appstruction Proposal"

    doc.setFontSize 14
    doc.setFontType "normal"
    doc.text 20, 30, body

    doc.save filename

  promptEmail: (event) =>
    subject = "Appstruction proposal"
    body = @generatePromptBody()
    body = encodeURIComponent body
    window.location.href = "mailto:?subject=#{subject}&body=#{body}";

  resetJob: =>
    console.log "Reseting job"
    @current.destroy()
    @navigate "home"
    true

  saveJob: (event) =>
    console.log "Saving job"

    unless @current.isValid()
      alert @current.validationError
      false

    @current.save()
    Choices.addJobGroup @current
    Choices.save()
    @jobs.add @current
    console.log JSON.stringify @current.toJSON()
    true

  addComponent: (routeType) =>
    @current.get(routeType).add {} if routeType in Choices.get "jobRoutes"

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

  validateComponent: (event) =>
    event.preventDefault()
    routeType = $(event.currentTarget).data "type"
    console.log "Validating #{routeType}"

    last = @current.get(routeType).last()
    unless last.isValid()
      alert last.validationError
      null

    console.log "Adding #{routeType} to active job"
    @addComponent routeType
    last
