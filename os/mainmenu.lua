os.pullEvent = os.pullEventRaw
menuSelectedOption = 1
clockTimerDelay = 0.05
clockTimer = os.startTimer(clockTimerDelay)
switch = true
menuOptions = {"Lua Shell",
                "Programs",
                "Uninstall",
                "Reboot"}

require("menutools")
require("global/variables")

function drawMainMenu(opt)
    
    printHeader()
    
    printCenteredY(yMid -1, "Start Menu")
    printCenteredY(yMid, " ")

    for index = 1, table.getn(menuOptions) do
        printIfSelected(index, yMid + index, menuOptions[index], opt)
    end
end

term.clear()

while switch == true do

    local time = os.time()
    local formattedTime = textutils.formatTime(time, false)
    local date = os.date()
    
    local events = {os.pullEvent()}
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
                shell.run("os/myprograms.lua")
                break

            elseif menuSelectedOption == 3 then
                resetScreen()
                shell.run("os/uninstall.lua")
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

