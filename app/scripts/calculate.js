function getSubTotalMaterials()
{
	runningTotal = 0;
	for (var i=1;i<=materialsSubDivs;i++){
		var materials_quantity =$$('#materials_quantity_' + i).val();
    	var materials_price =$$('#materials_price_' + i).val();
		runningTotal = runningTotal + (materials_quantity * materials_price);
	}

    return runningTotal;
}

function getSubTotalEquipment()
{
	runningTotal = 0;
	for (var i=1;i<=equipmentSubDivs;i++){
		var equipment_quantity =$$('#equipment_quantity_' + i).val();
    	var equipment_rate =$$('#equipment_rate_' + i).val();
		runningTotal = runningTotal + (equipment_quantity * equipment_rate);
	}

    return runningTotal;
}

function getSubTotalLabor()
{
	runningTotal = 0;
	for (var i=1;i<=laborSubDivs;i++){
		var labor_quantity =$$('#labor_number_' + i).val();
    	var labor_unit =$$('#labor_unit_' + i).val();
    	var labor_rate =$$('#labor_rate_' + i).val();
		runningTotal = runningTotal + (labor_quantity * labor_unit * labor_rate);
	}

    return runningTotal;
}

function getGrandTotal()
{
	
	var equipment = $$('#showcalculationequipment').html();
	var concrete = $$('#showcalculationconcrete').html();
	var labor = $$('#showcalculationlabor').html();
	var materials = $$('#showcalculationmaterials').html();
	var dirt = $$('#showcalculationdirt').html();
    return equipment + concrete + labor + materials + dirt;

}

function resetJobMaker(){
	$$('#materials_subtotals').append(getMaterialsDiv(materialsSubDivs));
    $$('#equipment_subtotals').append(getEquipmentDiv(equipmentSubDivs));
    $$('#labor_subtotals').append(getLaborDiv(laborSubDivs));
    equipmentSubDivs = equipmentSubDivs + 1; 
    laborSubDivs = laborSubDivs + 1;
    materialsSubDivs = materialsSubDivs + 1; 
}

var equipmentSubDivs=0;  
var laborSubDivs=0;
var materialsSubDivs=0;