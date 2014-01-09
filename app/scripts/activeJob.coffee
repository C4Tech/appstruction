Labor = require "scripts/labor"
LaborCollection = require "scripts/labor.collection"

class SearchView extends Backbone.View.extend
    initialize: ->
        @render()
    render: ->
        template = Handlebars.compile $("#search_template").html()
        @el.html template

$$('.job_load_label').tap -> 
	accounts = new JobCollection();
	accounts.fetch()
	modelss = accounts.models
	activeJob = getJobByID this.id, modelss
	mySearchView = new SearchView()
	mySearchView.initialize
	$$('#search_container').html(mySearchView)
	return true

loadActiveJob = (job) -> 
	loadMaterials(job)
	loadEquipment(job)
	loadLabor(job)
	loadConcrete(job)

loadLabor = (job) -> 
	laborSubDivs = 2
	laborObjects = job.attributes.labor
	$$('#labor_subtotals').html('')
	for l in laborObjects
		laborHTML = getHTMLforLaborObject l, laborSubDivs
		$$('#labor_subtotals').append(laborHTML)

loadEquipment = (job) -> 
	console.log(job)

loadMaterials = (job) -> 
	console.log(job)

loadConcrete = (job) -> 
	console.log(job)

getJobByID = (id, modells) -> 
	for model in modells
		return model if model.id=id
	return "can't find model"

activeJob = new JobModel(
	materials: new MaterialCollection(),
	labor: new LaborCollection(),
	equipment: new EquipmentCollection(),
	name: 'Default',
	profitMargin: 1.07	
)

# @todo: convert to a View method
$$(document).on "change", "#labor", ->
    LaborCollection.setTotal()
    true

# @todo: convert to a View method
$$("#add_another_labor").tap ->
	laborObject = Labor.get(false, true)
    Labor.calculate()
    if laborObject
    	activeJob.get('labor').add(laborObject)
    	Labor.create()

    return true
