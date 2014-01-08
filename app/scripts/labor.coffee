class LaborModel extends AnotherModel
    validateFields: ["number", "unit", "rate"]

class LaborCollection extends Backbone.Collection
    model: LaborModel
    localStorage: new Backbone.LocalStorage("cole-labor")

laborDivs = new LaborCollection
# @todo: make dynamic
laborSubDivs = 2

# @todo: convert to Handlebars template and Backbone View
getLaborDiv = (x) -> 
    "<div id='labor_subdiv_" + x + "' class='form subdiv'>
        <fieldset>
            <select>
                <option value='1'>Finishers</option>
                <option value='2'>Supervisors</option>
                <option value='3'>Forms crp</option>
                <option value='4'>Laborers</option>
                <option value='5'>Driver</option>
                <option value='6'>Operator</option>
            </select>
        </fieldset>
        <fieldset>
                <input placeholder='Number' id='labor_number_" + x +  "' type='number'></input>
                <input placeholder='Unit' id='labor_unit_" + x +  "' type='number'></input>
                <input placeholder='Rate' id='labor_rate_" + x +  "' type='number'></input>
        </fieldset>        
    </div>"

getLaborObject = (rowId) ->
    new LaborModel
        number: $$("#labor_number_" + rowId).val()
        unit: $$("#labor_unit_" + rowId).val()
        rate : $$("#labor_rate_" + rowId).val()

# @todo: convert to a View method
resetLaborRow = (rowId) ->
    $$("#labor_number_" + rowId).val null
    $$("#labor_unit_" + rowId).val null
    $$("#labor_rate_" + rowId).val null
    true

# @todo: convert to a Model method
calculateLaborRow = (idx) ->
    quantity = $$("#labor_number_" + idx).val()
    unit = $$("#labor_unit_" + idx).val()
    rate = $$("#labor_rate_" + idx).val()
    cost = quantity * rate * unit
    console.log "labor row ##{idx}: #{quantity} (#{unit}) @ #{rate} = #{cost}"
    cost

# @todo: convert to a Collection method
calculateLabor = ->
    total = 0
    # @todo: make dynamic
    total += calculateLaborRow(idx) for idx in [0...laborSubDivs+1]
    console.log "labor total", total
    total

# @todo: convert to a View method
setLaborSubtotal = ->
    $$("#showcalculationlabor").text calculateLabor()
    true

# @todo: convert to a View method
$$(document).on "change", "#labor", ->
    setLaborSubtotal()
    true