class MaterialModel extends Backbone.Model
    validate: (attrs, options) ->
        "You must enter a quantity" if !attrs.quantity?
        "You must enter a quantity" if attrs.quantity==0
        "You must enter a quantity" if attrs.quantity==""
        "Quantity must be a number" if isNaN(attrs.quantity)
        "Quantity can't be less than 0" if (attrs.quantity < 0)
        "You must enter a price" if !attrs.price?
        "Price can't be less than 0" if (attrs.price < 0)
        ""
        "Price must be a number" if isNaN(attrs.price)
        "You must enter a quantity" if attrs.price==""

class MaterialCollection extends Backbone.Collection
    model: MaterialModel
    localStorage: new Backbone.LocalStorage("cole-materials")

materialsDivs = new MaterialCollection
# @todo: make dynamic
materialsSubDivs = 2

# @todo: convert to Handlebars template and Backbone View
getMaterialsDiv = (x) -> 
    "<div id='materials_subdiv_" + x + "' class='form subdiv'>
        <fieldset>
            <select>
                <option value='1'>Wire(sheet)</option>
                <option value='2'>Keyway (lf)</option>
                <option value='3'>Stakes (ea.)</option>
                <option value='4'>Cap (lf)</option>
                <option value='5'>Dowells  (ea.)</option>
                <option value='6'>2x8x20  (lf)</option>
                <option value='7'>Misc</option>
            </select>
        </fieldset>
        <fieldset>
            <input placeholder='Quantity' id='materials_quantity_" + x + "' type='text'></input>
            <input placeholder='Price' id='materials_price_" + x + "' type='text'></input>
        </fieldset>
    </div>"

getMaterialObject = (rowId) ->
    new MaterialModel
        quantity : $$('#materials_quantity_' + rowId).val()
        price: $$('#materials_price_' + rowId).val()

# @todo: convert to a View method
resetMaterialRow = (rowId) ->
    $$("#materials_quantity_" + rowId).val null
    $$("#materials_price_" + rowId).val null
    true

# @todo: convert to a Model method
calculateMaterialRow = (idx) ->
    quantity = $$("#materials_quantity_" + idx).val()
    price = $$("#materials_price_" + idx).val()
    cost = quantity * price
    console.log "material row ##{idx}: #{quantity}@#{price} = #{cost}"
    cost

# @todo: convert to a Collection method
calculateMaterial = ->
    total = 0
    # @todo: make dynamic
    total += calculateMaterialRow(idx) for idx in [0...materialsSubDivs+1]
    console.log "material total", total
    total

# @todo: convert to a View method
setMaterialSubtotal = ->
    $$("#showcalculationmaterials").text calculateMaterial()
    true

# @todo: convert to a View method
$$(document).on 'change', '#materials', ->
    setMaterialSubtotal()
    true

# @todo: convert to a View method
$$('#add_another_materials').tap ->
    # @todo: make dynamic
    lastRow = materialsSubDivs

    row = getMaterialObject lastRow
    if (!row.isValid())
        alert row.validationError
        resetMaterialRow lastRow
        setMaterialSubtotal()
    else
        materialsDivs.add row
        lastRow++
        # @todo: make dynamic
        materialsSubDivs++
        # the parameter is used to set id="materials_rate_{{ rowNumber }}", as in id="materials_rate_3"
        $$('#materials_subtotals').append getMaterialsDiv lastRow

    true
