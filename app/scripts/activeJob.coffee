$$('.job_load_label').tap -> 
	accounts = new JobCollection();
	accounts.fetch()
	modelss = accounts.models
	newActiveJob = getJobByID this.id, modelss

getJobByID = (id, modells) -> 
	for model in modells
		return model 
	return "can't find model"

activeJob = new JobModel(
	materials: new MaterialCollection(),
	labor: new LaborCollection(),
	equipment: new EquipmentCollection(),
	name: 'Default',
	profitMargin: 1.07	
)