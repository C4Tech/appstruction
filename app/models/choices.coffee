class ChoicesModel extends Backbone.Model
    localStorage: new Backbone.LocalStorage "cole-choices"
    url: "choices"

    defaults:
        equipment_type_options: [
                id: "1"
                text: "Dump Truck"
            ,
                id: "2"
                text: "Excavator"
            ,
                id:"3"
                text: "Bobcat"
            ,
                id:"4"
                text: "C pump"
            ,
                id:"5"
                text: "Piles"
            ,
                id:"6"
                text: "Trial"
            ,
                id:"7"
                text: "Util Truck"
        ]

        group_name_options: []

        job_type_options: [
            id: "1"
            text: "Slab"
        ,
            id: "2"
            text: "GB- H"
        ,
            id:"3"
            text: "GB - H1A"
        ,
            id:"4"
            text: "GB - V"
        ,
            id:"5"
            text: "Piles"
        ,
            id:"6"
            text: "Truck Well"
        ]

        labor_type_options: [
                id: "1"
                text: "Finishers"
            ,
                id: "2"
                text: "Supervisors"
            ,
                id:"3"
                text: "Forms crp"
            ,
                id:"4"
                text: "Laborers"
            ,
                id:"5"
                text: "Driver"
            ,
                id:"6"
                text: "Operator"
        ]

        material_type_options: [
                id: "1"
                text: "Wire (sheet)"
            ,
                id: "2"
                text: "Keyway (lf)"
            ,
                id:"3"
                text: "Stakes (ea.)"
            ,
                id:"4"
                text: "Cap (lf)"
            ,
                id:"5"
                text: "Dowells  (ea.)"
            ,
                id:"6"
                text: "2x8x20  (lf)"
            ,
                id:"7"
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

choices = new ChoicesModel
    id: 1
choices.fetch()
module.exports = choices
