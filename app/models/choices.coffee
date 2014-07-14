class ChoicesModel extends Backbone.Model
    localStorage: new Backbone.LocalStorage "cole-choices"
    url: "choices"

    defaults:
        concrete_type_options: [
                id: "1"
                text: "Sidewalk"
            ,
                id: "2"
                text: "Foundation"
            ,
                id: "3"
                text: "Curb"
            ,
                id: "4"
                text: "Footings"
            ,
                id: "5"
                text: "Driveway"
        ]

        concrete_type_options_display:
            singular:
                '1': 'sidewalk'
                '2': 'foundation'
                '3': 'curb'
                '4': 'footing'
                '5': 'driveway'
            plural:
                '1': 'sidewalks'
                '2': 'foundations'
                '3': 'curbs'
                '4': 'footings'
                '5': 'driveways'

        equipment_type_options: [
                id: "1"
                text: "Dump Truck"
            ,
                id: "2"
                text: "Excavator"
            ,
                id: "3"
                text: "Bobcat"
            ,
                id: "4"
                text: "Concrete pump"
            ,
                id: "5"
                text: "Concrete saw"
            ,
                id: "6"
                text: "Piles"
            ,
                id: "7"
                text: "Trial"
            ,
                id: "8"
                text: "Util Truck"
            ,
                id: "9"
                text: "Trowel machine"
        ]

        equipment_type_options_display:
            singular:
                '1': 'dump truck'
                '2': 'excavator'
                '3': 'bobcat'
                '4': 'concrete pump'
                '5': 'concrete saw'
                '6': 'pile'
                '7': 'trial'
                '8': 'util truck'
                '9': 'trowel machine'
            plural:
                '1': 'dump trucks'
                '2': 'excavators'
                '3': 'bobcats'
                '4': 'concrete pumps'
                '5': 'concrete saws'
                '6': 'piles'
                '7': 'trials'
                '8': 'util trucks'
                '9': 'trowel machines'

        group_name_options: []

        job_groups: []

        job_type_options: [
                id: "1"
                text: "Municipal"
            ,
                id: "2"
                text: "Commercial"
            ,
                id: "3"
                text: "Residential"
            ,
                id: "4"
                text: "Civil"
            ,
                id: "5"
                text: "Structural"
        ]

        job_routes: [
            'concrete',
            'labor',
            'materials',
            'equipment',
            'subcontractor',
        ]

        labor_type_options: [
                id: "1"
                text: "Finishers"
            ,
                id: "2"
                text: "Supervisors"
            ,
                id: "3"
                text: "Forms crp"
            ,
                id: "4"
                text: "Laborers"
            ,
                id: "5"
                text: "Driver"
            ,
                id: "6"
                text: "Operator"
            ,
                id: "7"
                text: "Carpenter"
            ,
                id: "8"
                text: "Ironworker"
        ]

        labor_type_options_display:
            singular:
                '1': 'finisher',
                '2': 'supervisor',
                '3': 'forms crp',
                '4': 'laborer',
                '5': 'driver',
                '6': 'operator',
            plural:
                '1': 'finishers',
                '2': 'supervisors',
                '3': 'forms crp',
                '4': 'laborers',
                '5': 'drivers',
                '6': 'operators',

        material_type_options: [
                id: "1"
                text: "Wire (sheet)"
            ,
                id: "2"
                text: "Keyway (lf)"
            ,
                id: "3"
                text: "Stakes (ea.)"
            ,
                id: "4"
                text: "Cap (lf)"
            ,
                id: "5"
                text: "Dowells  (ea.)"
            ,
                id: "6"
                text: "2x8x20  (lf)"
            ,
                id: "7"
                text: "Misc"
        ]

        material_type_options_display:
            singular:
                '1': 'wire'
                '2': 'keyway'
                '3': 'stake'
                '4': 'cap'
                '5': 'dowell'
                '6': 'lf of 2x8x20'
                '7': 'misc'
            plural:
                '1': 'wire'
                '2': 'keyways'
                '3': 'stakes'
                '4': 'caps'
                '5': 'dowells'
                '6': 'lf of 2x8x20'
                '7': 'misc'

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

        price_options_display:
            singular:
                in: 'cubic inch'
                ft: 'cubic foot'
                yd: 'cubic yard'
                cm: 'cubic centimeter'
                m: 'cubic meter'
            plural:
                in: 'cubic inches'
                ft: 'cubic feet'
                yd: 'cubic yards'
                cm: 'cubic centimeters'
                m: 'cubic meters'

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

        time_options_display:
            singular:
                'hour': 'hour'
                'day': 'day'
                'week': 'week'
                'month': 'month'
            plural:
                'hour': 'hours'
                'day': 'days'
                'week': 'weeks'
                'month': 'months'

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

    getTextById: (options_name, id) ->
        options = @.get options_name
        item_found = item for item in options when item.id == id
        if item_found?
            return item_found.text
        return null

    addJobGroup: (job) ->
        group_option = item for item in @attributes.group_name_options when item.id == job.attributes.group_id
        filtered_job_groups = item for item in @attributes.job_groups when item.group.id == job.attributes.group_id

        job_found = false

        if filtered_job_groups?
            selected_group = filtered_job_groups
            job_found = _.some selected_group.jobs, (item_job) ->
                item_job.id == job.id
        else
            selected_group =
                group:
                    id: group_option.id
                    name: group_option.text

        unless job_found
            unless selected_group.jobs?
                selected_group.jobs = []

            selected_group.jobs.push
                id: job.id
                name: job.attributes.job_name

        unless filtered_job_groups?
            @attributes.job_groups.push selected_group

        return null

    removeJobGroup: (job) ->
        new_job_groups = []

        for item in @attributes.job_groups
            filtered_jobs = item.jobs.filter (job_item) ->
                return job_item.id != job.id

            if filtered_jobs.length == 0
                @attributes.group_name_options = _(@attributes.group_name_options).reject (group_item) ->
                    group_item.id == job.attributes.group_id
            else
                new_item =
                    group: item.group
                    jobs: filtered_jobs

                new_job_groups.push new_item

        @attributes.job_groups = new_job_groups
        return null

choices = new ChoicesModel
    id: 1
choices.fetch()
module.exports = choices
