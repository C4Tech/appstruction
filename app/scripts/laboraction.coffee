# @todo: convert to a View method
$$("#add_another_labor").tap ->
    # @todo: make dynamic
    lastRow = laborSubDivs
    
    row = getLaborObject lastRow
    console.log row
    if (!row.isValid())
        alert row.validationError
        resetLaborRow row
        setLaborSubtotal()
    else
        activeJob.get('labor').add(row)
        laborDivs.add row
        lastRow++
        # @todo: make dynamic
        laborSubDivs++
        # the parameter is used to set id="labor_rate_{{ rowNumber }}", as in id="labor_rate_3"
        $$("#labor_subtotals").append getLaborDiv lastRow

    true
