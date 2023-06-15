term.clear()
os.pullEvent = os.pullEventRaw
local menuSelectedOption = 1
local clockTimerDelay = 0.05
local clockTimer = os.startTimer(clockTimerDelay)
local switch = true
local menuOptions = {"Lua Shell",
                    "Programs",
                    "Uninstall",
                    "Reboot"}

require("menutools")

local function drawMainMenu(opt)
    

    printAtPos(1, 1, "fireOs")
    printAtPos(1, 2, "Version: Alpha 1.0")
    
    printCenteredY(yMid -1, "Start Menu")
    printCenteredY(yMid, " ")

    for index = 1, table.getn(menuOptions) do
        printIfSelected(index, yMid + index, menuOptions[index], opt)
    end

    -- printIfSelected(1, yMid + 1,   "Lua Shell")
    -- printIfSelected(2, yMid + 2, "Programs")
    -- printIfSelected(3, yMid + 3, "Uninstall")
    -- printIfSelected(4, yMid + 4, "Reboot")
end

while switch == true do

    local time = os.time()
    local formattedTime = textutils.formatTime(time, false)
    local date = os.date()
    
    events = {os.pullEvent()}
    if events[1] == "timer" then
        if events[2] == clockTimer then
            drawMainMenu(menuSelectedOption)
            overwriteAtPos(screenWidth - string.len(formattedTime) + 1, 2, formattedTime)
            overwriteAtPos(screenWidth - string.len(date) + 1, 1, date)
            clockTimer = os.startTimer(clockTimerDelay)
        end
    end
    --ENTER
    if events[1] == 'key' then
        if events[2] == keyEnter then
            if menuSelectedOption == 1 then
                resetScreen()
                error()
                
            elseif menuSelectedOption == 2 then
                resetScreen()
                shell.run("fireOs/myprograms.lua")
                break

            elseif menuSelectedOption == 3 then
                resetScreen()
                shell.run("fireOs/uninstall.lua")
                break

            elseif menuSelectedOption == 4 then
                os.reboot()
            end
        --GO UP MENU
        elseif events[2] == keyUp or events[2] == keyW then
            if menuSelectedOption == 1 then
                menuSelectedOption = table.getn(menuOptions)
            
            elseif menuSelectedOption > 1 then
                menuSelectedOption = menuSelectedOption - 1
            end
        --GO DOWN MENU
        elseif events[2] == keyDown or events[2] == keyS then
            if menuSelectedOption == table.getn(menuOptions) then
                menuSelectedOption = 1
            
            elseif menuSelectedOption < table.getn(menuOptions) then
                menuSelectedOption = menuSelectedOption + 1
            end
        end
    end
end

