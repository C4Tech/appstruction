class JobModel extends Backbone.Model
    localStorage: new Backbone.LocalStorage("cole-job")

class JobCollection extends Backbone.Collection
    localStorage: new Backbone.LocalStorage("cole-job")

getJob = ->
    new JobModel
        name : "test"

# @toLocaleDateString convert to Views method and make dynamic
resetJob = ->
    $$('#materials_subtotals').append getMaterialsDiv materialsSubDivs
    $$('#equipment_subtotals').append getEquipmentDiv equipmentSubDivs
    $$('#labor_subtotals').append getLaborDiv laborSubDivs
    true

calculateJob = ->
    equipment = parseInt $$('#showcalculationequipment').text()
    concrete = parseInt $$('#showcalculationconcrete').text()
    labor = parseInt $$('#showcalculationlabor').text()
    materials = parseInt $$('#showcalculationmaterials').text()
    dirt = parseInt $$('#showcalculationdirt').text()
    total = equipment + concrete + labor + materials
    console.log "Job total: #{equipment} + #{concrete} + #{labor} + #{materials} + #{dirt} = #{total}"
    total

setJobTotal = ->
    $$('#grand_total').text calculateJob()
    true

jobSaved = (model) ->
    jobs = new JobCollection
    allJobs = jobs.fetch()
    console.log "Fetching jobs", allJobs

$$(document).on 'change', '#makerTwo', ->
    setJobTotal()    
    true

$$('#makerTwo').ready ->
    resetJob()
    true

$$('#savejobbutton').tap ->
    job = getJob()
    job.save
        success: (model, response, options) ->
            console.log model, response, options
            alert response
            jobSaved()
            Lungo.Router.article "savejob", "makerTwo"
        error: (model, xhr, options) ->
            console.log model, xhr, options
            alert "Save failed"
    true
