local disarm_rc_channel = rc:get_channel(5) -- rc channel

local pre_disarm = 0

local time_window = 2000 -- microseconds

local start = 0 -- counter start time

local STAB_mode_num = 0

local sw_prev_pos = 0
local sw_pos = 0
local mode_num = 0
local previous_mode_num = 0

function update () -- periodic function that will be called

    sw_prev_pos = sw_pos
    sw_pos = disarm_rc_channel:get_aux_switch_pos()
    mode_num = vehicle:get_mode()
    
    if mode_num ~= STAB_mode_num then -- save previous mode
        previous_mode_num = mode_num
    end

    if sw_pos == 2 and pre_disarm == 0 and sw_prev_pos ~= 2 then -- first stage pre_disarm / stab mode engage
        start = millis()
        pre_disarm = 1
    end  

    if millis() > start + time_window and pre_disarm ~= 0 then -- reset pre_disarm stage after x seconds
        pre_disarm = 0
    end

    if sw_pos == 0 and pre_disarm == 1 then -- second stage pre_disarm
        pre_disarm = 2
    end

    if sw_pos == 2 and pre_disarm == 2 then -- final stage disarm
        arming:disarm()
        pre_disarm = 0
        gcs:send_text(6, "Disarmed by emergency switch!")
    end

    if sw_pos == 2 and mode_num ~= STAB_mode_num and sw_prev_pos ~= 2 and pre_disarm ~= 2 then -- set stab mode
        if vehicle:set_mode(STAB_mode_num) then -- set stab mode
            --gcs:send_text(6, "Stabilize mode selected")
        else
            --gcs:send_text(6, "Cannot select Stabilize mode")
        end
    end  

    if sw_pos == 0 and sw_prev_pos ~= 0 then -- remove stab mode
        if vehicle:set_mode(previous_mode_num) then-- set previous mode 
            --gcs:send_text(6, "Previous mode selected")
        else
            --gcs:send_text(6, "Cannot select previous mode")
        end
    end

    return update, 20

end

gcs:send_text(6, "safe_disarm_and_stabilize_apex.lua is running")

return update()
