
os.pullEvent = os.pullEventRaw
menuSelectedOption = 1
clockTimerDelay = 0.05
clockTimer = os.startTimer(clockTimerDelay)
switch = true
myProgramsOptions = {"Floppy Disk Manager", " ", " ", "Exit"}

require("menutools")
require("global/variables")

local function drawMyProgramsList(opt)
   

    printHeader()
    
    printCenteredY(yMid -1, "Programs list")
    printCenteredY(yMid, " ")

    for index = 1, table.getn(myProgramsOptions) do
        printIfSelected(index, yMid + index, myProgramsOptions[index], opt)
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
            drawMyProgramsList(menuSelectedOption)
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
                shell.run("os/myprograms/diskTool.lua")
                break

            elseif menuSelectedOption == 2 then
                --program 2

            elseif menuSelectedOption == 3 then
                --program 3

            elseif menuSelectedOption == 4 then
                resetScreen()
                shell.run("os/mainmenu.lua")
                break
                
            end
        --GO UP MENU
        elseif events[2] == keyUp or events[2] == keyW then
            if menuSelectedOption == 1 then
                menuSelectedOption = table.getn(myProgramsOptions)
            
            elseif menuSelectedOption > 1 then
                menuSelectedOption = menuSelectedOption - 1
            end
        --GO DOWN MENU
        elseif events[2] == keyDown or events[2] == keyS then
            if menuSelectedOption == table.getn(myProgramsOptions) then
                menuSelectedOption = 1
            
            elseif menuSelectedOption < table.getn(myProgramsOptions) then
                menuSelectedOption = menuSelectedOption + 1
            end
        end
    end
end


