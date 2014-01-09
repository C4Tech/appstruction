class JobModel extends Backbone.Model
    localStorage: new Backbone.LocalStorage("cole-job")

class JobCollection extends Backbone.Collection
    localStorage: new Backbone.LocalStorage("cole-job")
    url:'/jobs'

allJobs = null

getJob = ->
    new JobModel
        name : "test"

# @toLocaleDateString convert to Views method and make dynamic
resetJob = ->
    $$('#materials_subtotals').append getMaterialsDiv materialsSubDivs
    $$('#equipment_subtotals').append getEquipmentDiv equipmentSubDivs
    $$('#labor_subtotals').append getBlankLaborHTML laborSubDivs
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

$$(document).on 'change', '#makerTwo', ->
    setJobTotal()    
    true

$$('#makerTwo').ready ->
    resetJob()
    true
