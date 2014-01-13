PageView = require "scripts/views/page"

module.exports = class AppRouter extends Backbone.Router
    routes:
        "help": "help",    // #help
        "search/:query":        "search",  // #search/kiwis
        "search/:query/p:page": "search"   // #search/kiwis/p7

    home: ->
        new PageView
            title: "Cole"
            links: [
                "create": "Create new estimate"
                "jobs": "Load estimate"
            ]
            article:
                id: "start"
                content: ""

    create: ->
        new PageView
            title: "Maker One"
            back:
                url: "home"
                title: "Home"

        new FormView
            id: "job-form-type"
            next: "concrete"

        jobType = require "scripts/templates/job-type"
        $(".page .job-component").prepend jobType()
        true


modules.exports = new AppRouter
