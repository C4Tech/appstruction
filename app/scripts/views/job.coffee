View = require "scripts/views/base"

module.exports = class JobView extends View
    templateFile: "job.view.row"

    tagName: "li"

    className: "job-list"
