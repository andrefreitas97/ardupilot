
local mode_rc = param:get('FLTMODE_CH')

local rc_speed_switch = rc:get_channel(mode_rc) -- rc channel

-- normal loiter parameters:

local normal_loit_speed = 2000 -- centimeters per second
    
local normal_speed_kmh = 0.036 * normal_loit_speed -- km/h
    
local normal_loit_max_angle = 30 -- degrees of tilt

local normal_angle_max = 3000 -- centidegrees of tilt
    
local normal_climb_speed = 500 -- centimeters per second
    
local normal_descent_speed = 300 -- centimeters per second
    
local normal_accel_z = 500 -- meters per second^2
    
local normal_jerk_z = 10 -- meters per second^3

-- fast loiter parameters:

local fast_loit_speed = 2800 -- centimeters per second

local fast_speed_kmh = 0.036 * fast_loit_speed -- km/h

local fast_loit_max_angle = 40 -- degrees of tilt

local fast_angle_max = 4000 -- centidegrees of tilt

local fast_climb_speed = 750 -- centimeters per second

local fast_descent_speed = 350 -- centimeters per second

local fast_accel_z = 500 -- meters per second^2

local fast_jerk_z = 10 -- meters per second^3


function update() -- periodic function that will be called

    sw_pos = rc_speed_switch:get_aux_switch_pos()

    if sw_pos == 0 and selected_mode ~= 0 then -- althold

        param:set('ANGLE_MAX',normal_angle_max)
        param:set('PILOT_SPEED_UP',normal_climb_speed)
        param:set('PILOT_SPEED_DN',normal_descent_speed)
        param:set('PILOT_ACCEL_Z',normal_accel_z)
        param:set('PSC_JERK_Z',normal_jerk_z)

        gcs:send_text(1, string.format('AltHold (No horizontal position control)'))
        selected_mode = 0

    elseif sw_pos == 1 and selected_mode ~= 1 then -- normal loiter
    
        param:set('ANGLE_MAX',normal_angle_max)
        param:set('LOIT_ANG_MAX',normal_loit_max_angle)
        param:set('LOIT_SPEED',normal_loit_speed)
        param:set('PILOT_SPEED_UP',normal_climb_speed)
        param:set('PILOT_SPEED_DN',normal_descent_speed)
        param:set('PILOT_ACCEL_Z',normal_accel_z)
        param:set('PSC_JERK_Z',normal_jerk_z)
    
        gcs:send_text(1, string.format('Normal Loiter (%.0f km/h/ %d tilt/ normal Vspeed)',normal_speed_kmh, normal_loit_max_angle))
        selected_mode = 1

    elseif sw_pos == 2 and selected_mode ~= 2 then -- fast loiter

        param:set('ANGLE_MAX',fast_angle_max)
        param:set('LOIT_ANG_MAX',fast_loit_max_angle)
        param:set('LOIT_SPEED',fast_loit_speed)
        param:set('PILOT_SPEED_UP',fast_climb_speed)
        param:set('PILOT_SPEED_DN',fast_descent_speed)
        param:set('PILOT_ACCEL_Z',fast_accel_z)
        param:set('PSC_JERK_Z',fast_jerk_z)
      
        gcs:send_text(1, string.format('Fast Loiter (%.0f km/h/ %d tilt/ faster Vspeed)',fast_speed_kmh, fast_loit_max_angle))
        selected_mode = 2
    end   

    return update, 20 -- request "update" to be rerun again 20 milliseconds from now
end

gcs:send_text(6, "sport_mode_apex.lua is running")

return update()
