var SomeCollection = Backbone.Collection.extend({
    localStorage: new Backbone.LocalStorage("SomeCollection")
});

var EquipmentSubtotal = Backbone.Model.extend({
  validate: function(attrs, options) {
    if (attrs.quantity){
    	 if (isNaN(attrs.quantity)){
      		return "Quantity can't be less than 0";
    	}
    	if (attrs.quantity < 0) {
      		return "Quantity can't be less than 0";
    	}
	}
	else{
		return "You must enter a quantity";
	}
	if (attrs.rate){
    	 if (isNaN(attrs.rate)){
      		return "Rate mast be a number";
    	}
    	if (attrs.rate < 0) {
      		return "Rate can't be less than 0";
    	}
	}
	else{
		return "You must enter a rate";
	}
  }
});

var LaborSubtotal = Backbone.Model.extend({
  validate: function(attrs, options) {
    if (attrs.rate){
       if (isNaN(attrs.rate)){
          return "Quantity can't be less than 0";
      }
      if (attrs.rate < 0) {
          return "Quantity can't be less than 0";
      }
  }
  else{
    return "You must enter a rate";
  }
  if (attrs.unit){
       if (isNaN(attrs.unit)){
          return "Rate must be a number";
      }
      if (attrs.unit < 0) {
          return "Rate can't be less than 0";
      }
  }
  else{
    return "You must enter a rate";
  }
  if (attrs.number){
       if (isNaN(attrs.number)){
          return "The number must be a number";
      }
      if (attrs.number < 0) {
          return "Number can't be less than 0";
      }
  }
  else{
    return "You must enter a number";
  }
  }
});

var MaterialsSubtotal = Backbone.Model.extend({
  validate: function(attrs, options) {
    if (attrs.quantity){
       if (isNaN(attrs.quantity)){
          return "Quantity can't be less than 0";
      }
      if (attrs.quantity < 0) {
          return "Quantity can't be less than 0";
      }
  }
  else{
    return "You must enter a quantity";
  }
  if (attrs.price){
       if (isNaN(attrs.price)){
          return "The price must be a number";
      }
      if (attrs.price < 0) {
          return "Price can't be less than 0";
      }
  }
  else{
    return "You must enter a price";
  }
  }
});

function getEquipmentSubDivObject(equipmentSubDivs)
{
  var subDivRate = $$('#equipment_rate_' + equipmentSubDivs).val();
  var subDivQuantity = $$('#equipment_quantity_' + equipmentSubDivs).val();
  var one = new EquipmentSubtotal({
      rate : subDivRate,
      quantity: subDivQuantity
  });
  return one;
}

function getLaborSubDivObject(laborSubDivs)
{
  var subDivRate = $$('#labor_rate_' + laborSubDivs).val();
  var subDivUnit = $$('#labor_unit_' + laborSubDivs).val();
  var subDivNumber = $$('#labor_number_' + laborSubDivs).val();
  var one = new LaborSubtotal({
      rate : subDivRate,
      unit: subDivUnit,
      number: subDivNumber
  });

  return one;

}

function getMaterialsSubDivObject(materialsSubDivs)
{
  var subDivQuantity = $$('#materials_quantity_' + materialsSubDivs).val();
  var subDivPrice = $$('#materials_price_' + materialsSubDivs).val();
  var one = new MaterialsSubtotal({
      quantity : subDivQuantity,
      price: subDivPrice
  });
  return one;

}

function resetMaterialsSubDiv(materialsSubDivs){
  var quant = document.getElementById('materials_quantity_' + materialsSubDivs);
  quant.value = null;
  var pri = document.getElementById('materials_price_' + materialsSubDivs);
  pri.value = null;
}
 
function resetEquipmentSubDiv(equipmentSubDivs){
  var quant = document.getElementById('equipment_quantity_' + equipmentSubDivs);
  quant.value = null;
  var rate = document.getElementById('equipment_rate_' + equipmentSubDivs);
  rate.value = null;
}

function resetLaborSubDiv(laborSubDivs){
  var num = document.getElementById('labor_number_' + laborSubDivs);
  num.value = null;
  var uni = document.getElementById('labor_unit_' + laborSubDivs);
  uni.value = null;
  var rte = document.getElementById('labor_rate_' + laborSubDivs);
  rte.value = null;
}   

var LaborDivCollection = Backbone.Collection.extend({
  model: LaborSubtotal
});

var laborDivs = new LaborDivCollection();

var EquipmentDivCollection = Backbone.Collection.extend({
  model: EquipmentSubtotal
});

var equipmentDivs = new EquipmentDivCollection();

var MaterialsDivCollection = Backbone.Collection.extend({
   localStorage: new Backbone.LocalStorage("SomeCollection"), // Unique name within your app.
   model: MaterialsSubtotal
});

var materialsDivs = new MaterialsDivCollection();