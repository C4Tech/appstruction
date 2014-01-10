app = require "application"

# Start Lungo
Lungo.init
    name: 'Cole'
    version: '0.1'

navLink = (e) ->
    toSection = Lungo.dom(this).data "view-section"
    toArticle = Lungo.dom(this).data "view-article"

    if toSection
        Lungo.Router.section toSection
    else
        parent = Lungo.dom(this).parent "section"
        toSection = parent.attr "id"

    if toArticle
        Lungo.Router.article toSection, toArticle
    e

Lungo.dom("button.link").tap navLink
Lungo.dom("a").tap navLink

$$(document).on 'change', 'input, select', ->
    app.update()

$$('.job-list').tap ->
    app.load this.data "id"

$$(".add").tap ->
    app.addTo this.data "type"

$$('#savejobbutton').tap(function() {
    activeJob = getActiveJob();
    activeJob.save().done(function(res) {
        var jobs;
        console.log("done", res);
        jobs = new JobCollection;
        return allJobs = jobs.fetch().done(function(res) {
            return console.log("all", res);
        });
    });
    return true;
});