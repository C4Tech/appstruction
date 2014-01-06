class EquipmentModel extends Backbone.Model
    validate: (attrs, options) ->
        "You must enter a quantity" if !attrs.quantity?
        "Quantity can't be less than 0" if (attrs.quantity < 0)
        "You must enter a rate" if !attrs.rate?
        "Rate can't be less than 0" if (attrs.rate < 0)
        ""

class EquipmentCollection extends Backbone.Collection
    model: EquipmentModel
    localStorage: new Backbone.LocalStorage("cole-equipment")

equipmentDivs = new EquipmentCollection
# @todo: make dynamic
equipmentSubDivs = 2

# @todo: convert to Handlebars template and Backbone View
getEquipmentDiv = (x) ->  
    "<div id='equipment_subdiv_" + x + "' class='form subdiv'>
        <fieldset>
            <select>
                <option value='1'>Dump Truck</option>
                <option value='2'>Excavator</option>
                <option value='3'>Bobcat</option>
                <option value='4'>C pump</option>
                <option value='5'>Piles</option>
                <option value='6'>Trial</option>
                <option value='7'>Util Truck</option>
            </select>
        </fieldset>
        <fieldset>
            <input id='equipment_quantity_" + x + "' placeholder='Quantity'  type='text'></input>
            <input id='equipment_rate_" + x + "' placeholder='Rate' type='text'></input>
        </fieldset>
    </div>"    

getEquipmentObject = (rowId) ->
    new EquipmentModel
        quantity: $$("#equipment_quantity_" + rowId).val()
        rate : $$("#equipment_rate_" + rowId).val()

# @todo: convert to a View method
resetEquipmentRow = (rowId) ->
    $$("#equipment_quantity_" + rowId).val null
    $$("#equipment_rate_" + rowId).val null
    true

# @todo: convert to a Model method
calculateEquipmentRow = (idx) ->
    quantity = $$("#equipment_quantity_" + idx).val()
    rate = $$("#equipment_rate_" + idx).val()
    cost = quantity * rate
    console.log "equipment row ##{idx}: #{quantity}@#{rate} = #{cost}"
    cost

# @todo: convert to a Collection method
calculateEquipment = ->
    total = 0
    # @todo: make dynamic
    total += calculateEquipmentRow(idx) for idx in [0...equipmentSubDivs+1]
    console.log "equipment total: #{total}"
    total

# @todo: convert to a View method
setEquipmentSubtotal = ->
    $$("#showcalculationequipment").text calculateEquipment()
    true

# @todo: convert to a View method
$$(document).on "change", "#equipment", ->
    setEquipmentSubtotal()
    true

# @todo: convert to a View method
$$("#add_another_equipment").tap ->
    # @todo: make dynamic
    lastRow = equipmentSubDivs

    row = getEquipmentObject lastRow
    if (!row.isValid())
        alert row.validationError
        resetEquipmentRow lastRow
        setEquipmentSubtotal()
    else
        equipmentDivs.add row
        lastRow++
        # @todo: make dynamic
        equipmentSubDivs++ 
        # the parameter is used to set id="equipment_rate_{{ rowNumber }}", as in id="equipment_rate_3"     
        $$("#equipment_subtotals").append getEquipmentDiv lastRow

    true
