window.onload = function() {
    var allJobs = new JobCollection;
    allJobs.fetch();
    var HTML = "";
    allJobs.forEach(function(entry) {
        HTML = HTML + getJobHTML(entry.attributes.name, entry.attributes.id);
    });
    $$('#loaddetail').html(HTML);
};