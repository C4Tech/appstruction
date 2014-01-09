window.onload = (x) -> 
    allJobs = new JobCollection
    allJobs.fetch()
    models = allJobs.models
    HTML = ""
    for j in models
        HTML = HTML + getJobHTML j.attributes.name, j.attributes.id 
    $$('#loaddetail').html(HTML);

getJobHTML = (name, id) -> "<ul><a><li id='" + id + "' class='job_load_label'><strong>" + name + "</strong></li></a></ul>"