module.exports = class ChoicesModel extends Backbone.Model
    defaults: ->
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
