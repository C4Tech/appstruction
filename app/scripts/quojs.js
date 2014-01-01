$$(document).on('change', '#concreteForm', function() {
    var depth=$$('#concrete_depth').val();
    var width=$$('#concrete_width').val();
    var height=$$('#concrete_length').val();
    var quantity =$$('#concrete_quantity').val();
    var totalConcrete = depth * width * height * quantity;
    var concrete_price = $$('#concrete_price').val();
    var totalAmt = totalConcrete * concrete_price;
    $$('#showcalculationconcrete').text(totalAmt);
});

function resetEquipmentSubtotal(){
    var answer = getSubTotalEquipment();
    $$('#showcalculationequipment').text(answer);
}

function resetLaborSubtotal(){
    var answer = getSubTotalLabor();
    $$('#showcalculationlabor').text(answer);
}

$$(document).on('change', '#equipment', function() {
    resetEquipmentSubtotal();
});

$$(document).on('change', '#labor', function() {
    resetLaborSubtotal();
});

$$(document).on('change', '#makerTwo', function() {
    var answer = getGrandTotal();
    $$('#grand_total').text(answer);
});

$$(document).on('change', '#materials', function() {
    var answer = getSubTotalMaterials();
    $$('#showcalculationmaterials').text(answer);
});

$$('#add_another_labor').tap(function() {
    var one = getLaborSubDivObject(laborSubDivs);
    if (!one.isValid()){
        alert(one.validationError);
        resetLaborSubDiv(laborSubDivs);
        resetLaborSubtotal();
    }
    else{
        laborDivs.add(one);
        laborSubDivs = laborSubDivs + 1;
        $$('#labor_subtotals').append(getLaborDiv(laborSubDivs)); 
    }
});

$$('#add_another_equipment').tap(function() {
    var one = getEquipmentSubDivObject(equipmentSubDivs);
    if (!one.isValid()) {
        alert(one.validationError);
        resetEquipmentSubDiv(equipmentSubDivs);
        resetEquipmentSubtotal();
    }
    else{
        equipmentSubDivs = equipmentSubDivs + 1;
        $$('#equipment_subtotals').append(getEquipmentDiv(equipmentSubDivs)); //the parameter is used to set id="equipment_rate_equipmentSubDivs", as in id="equipment_rate_3"     
    }
});

$$('#add_another_materials').tap(function() {
    var one = getMaterialsSubDivObject(materialsSubDivs);
    if (!one.isValid()) {
        alert(one.validationError);
        resetMaterialsSubDiv(materialsSubDivs); //reset the div to null vals
    }
    else{
        materialsSubDivs = materialsSubDivs + 1;
        $$('#materials_subtotals').append(getMaterialsDiv(materialsSubDivs));
    }
});

$$('#makerTwo').ready(function() {
    resetJobMaker();
});