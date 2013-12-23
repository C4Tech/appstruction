getLaborDiv = (x) -> "<div id='labor_subdiv_" + x + "' class='form'>
                <fieldset>
                    <select>
                        <option value='1'>
                            Finishers
                        </option>
                        <option value='2'>
                            Supervisors
                        </option>
                        <option value='3'>
                            Forms crp
                        </option>
                        <option value='4'>
                            Laborers
                        </option>
                        <option value='5'>
                            Driver
                        </option>
                        <option value='6'>
                            Operator
                        </option>
                    </select>
                </fieldset>
                <fieldset>
                        <input placeholder='Number' id='labor_number_" + x +  "' type='text'></input>
                        <input placeholder='Unit' id='labor_unit_" + x +  "' type='text'></input>
                        <input placeholder='Rate' id='labor_rate_" + x +  "' type='text'></input>
                </fieldset>        
            </div>"