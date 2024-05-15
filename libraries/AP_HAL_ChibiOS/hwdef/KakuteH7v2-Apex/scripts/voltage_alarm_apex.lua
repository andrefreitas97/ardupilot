local TUNE = "BC"

local voltage_lower_limit = 10.5

local deadzone = 5

function update ()

    local voltage = battery:voltage(0)

    if voltage < voltage_lower_limit and voltage > deadzone and not arming:is_armed() then

            notify:play_tune(TUNE)
            gcs:send_text(6, string.format("Battery voltage too low! (%.2fV)", voltage))
            
    end

    return update, 5000
end

gcs:send_text(6, "voltage_alarm_apex.lua is running")

return update, 10000