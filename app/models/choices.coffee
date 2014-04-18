class ChoicesModel extends Backbone.Model
    localStorage: new Backbone.LocalStorage "cole-choices"
    url: "choices"

    defaults:
        equipment_type_options: [
                id: "Dump Truck"
                text: "Dump Truck"
            ,
                id: "Excavator"
                text: "Excavator"
            ,
                id: "Bobcat"
                text: "Bobcat"
            ,
                id: "C pump"
                text: "C pump"
            ,
                id: "Piles"
                text: "Piles"
            ,
                id: "Trial"
                text: "Trial"
            ,
                id: "Util Truck"
                text: "Util Truck"
        ]

        group_name_options: []

        job_groups: []

        job_type_options: [
                id: "Slab"
                text: "Slab"
            ,
                id: "GB- H"
                text: "GB- H"
            ,
                id: "GB - H1A"
                text: "GB - H1A"
            ,
                id: "GB - V"
                text: "GB - V"
            ,
                id: "Piles"
                text: "Piles"
            ,
                id: "Truck Well"
                text: "Truck Well"
        ]

        labor_type_options: [
                id: "Finishers"
                text: "Finishers"
            ,
                id: "Supervisors"
                text: "Supervisors"
            ,
                id: "Forms crp"
                text: "Forms crp"
            ,
                id: "Laborers"
                text: "Laborers"
            ,
                id: "Driver"
                text: "Driver"
            ,
                id: "Operator"
                text: "Operator"
        ]

        material_type_options: [
                id: "Wire (sheet)"
                text: "Wire (sheet)"
            ,
                id: "Keyway (lf)"
                text: "Keyway (lf)"
            ,
                id: "Stakes (ea.)"
                text: "Stakes (ea.)"
            ,
                id: "Cap (lf)"
                text: "Cap (lf)"
            ,
                id: "Dowells  (ea.)"
                text: "Dowells  (ea.)"
            ,
                id: "2x8x20  (lf)"
                text: "2x8x20  (lf)"
            ,
                id: "Misc"
                text: "Misc"
        ]

        measurement_options: [
                id: 'in'
                text: 'Inches'
            ,
                id: 'ft'
                text: 'Feet'
            ,
                id:'yd'
                text: 'Yards'
            ,
                id:'cm'
                text: 'Centimeters'
            ,
                id:'m'
                text: 'Meters'
        ]

        price_options: [
                id: 'in'
                text: 'Per Cubic Inch'
            ,
                id: 'ft'
                text: 'Per Cubic Foot'
            ,
                id: 'yd'
                text: 'Per Cubic Yard'
            ,
                id: 'cm'
                text: 'Per Cubic Centimeter'
            ,
                id: 'm'
                text: 'Per Cubic Meter'
        ]

        time_options: [
                id: "hour"
                text: "Hours"
            ,
                id: "day"
                text: "Days"
            ,
                id: "week"
                text: "Weeks"
            ,
                id: "month"
                text: "Months"
        ]

        time_per_options: [
                id: "hour"
                text: "Hourly"
            ,
                id: "day"
                text: "Daily"
            ,
                id: "week"
                text: "Weekly"
            ,
                id: "month"
                text: "Monthly"
        ]

    add_job_group: (job) ->
        group_option = item for item in @attributes.group_name_options when item.id == job.attributes.group_id
        filtered_job_groups = item for item in @attributes.job_groups when item.group.id == job.attributes.group_id

        job_found = false

        if filtered_job_groups?
            selected_group = filtered_job_groups
            job_found = _.some selected_group.jobs, (item_job) ->
                item_job.cid == job.cid
        else
            selected_group =
                group:
                    id: group_option.id
                    name: group_option.text

        unless job_found
            unless selected_group.jobs?
                selected_group.jobs = []

            selected_group.jobs.push
                cid: job.cid
                name: job.attributes.job_name

        unless filtered_job_groups?
            @attributes.job_groups.push selected_group

        # Return nothing
        null

choices = new ChoicesModel
    id: 1
choices.fetch()
module.exports = choices
