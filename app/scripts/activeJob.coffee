$$('.job_load_label').tap -> 
	alert "I knew it!" 

activeJob = new JobModel(
	materials: new MaterialCollection(),
	labor: new LaborCollection(),
	equipment: new EquipmentCollection(),
	name: 'Default',
	profitMargin: 1.07	
)