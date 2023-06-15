
require("./fireOs/menutools")

peripheralPositions = {"right", "left", "bottom", "top"}
diskToolsMenuOptions = {"Eject Disk",
                        "Set Disk Label",
                        "Get Disk Label",
                        "Get Disk ID",
                        "Get Mount Path",
                        "Copy to disk path",
                        "Copy disk to system",
                        "Print disk",
                        "Delete from disk",
                        "Play audio",
                        "Stop audio",
                        "Exit"}
os.pullEvent = os.pullEventRaw

-- checks for disk drive in all positions
for i=1, 4 do
    
    if peripheral.isPresent(peripheralPositions[i]) == true then
        hasDrive = true
        drive = peripheral.wrap(peripheralPositions[i])
        statusMessage = 'Drive at position: '..peripheralPositions[i]
        break
    end
    hasDrive = false
end



local menuSelectedOption = 1
switch = true

local function drawDiskToolsMenu(opt)
    
    printHeader()
    
    printCenteredY(yMid - 5, "Disk Tool Menu")
    printCenteredY(yMid - 4, " ")
    
    updateStatusMessage(statusMessage)

    for index = 1, table.getn(diskToolsMenuOptions) do
        local offset = index - 4
        local option = diskToolsMenuOptions[index]
        if option ~= nil and option ~= "Exit" then
            printIfSelected(index, yMid + offset, option, opt)
        else 
            printIfSelected(index, yMid + offset + 1, option, opt)
        end
    end
    -- printIfSelected(1, yMid - 2, "Eject Disk")
    -- printIfSelected(2, yMid - 1, "Set Disk Label")
    -- printIfSelected(3, yMid,     "Get Disk Label")
    -- printIfSelected(4, yMid + 1, "Get Disk ID")
    -- printIfSelected(5, yMid + 2, "Get Mount Path")
    -- printIfSelected(6, yMid + 3, "Has data")
    -- printIfSelected(7, yMid + 4, "Has audio")
    -- printIfSelected(8, yMid + 5, "Play audio")
    -- printIfSelected(9, yMid + 6, "Stop audio")
    
end

function hasDisk()
    if drive.hasData() then
        return true
    else
        updateStatusMessage("No disk in drive!")
        return false
    end
end

function updateStatusMessage(message)
    term.setTextColor(colors.green)
    overwriteAtPos(25, 1, "                                 ")
    overwriteAtPos(25, 1, message)
    statusMessage = message
    term.setTextColor(colors.white)
end

local function optionEjectDisk()
    if hasDisk() then
        drive.ejectDisk()
        updateStatusMessage("Disk Ejected!")
    end
end

local function optionSetDiskLabel()
    if hasDisk() then
        updateStatusMessage("Insert Disk Label:")
        diskLabel = readAtPos(25, 2)
        if diskLabel ~= "" then
            drive.setDiskLabel(diskLabel)
            updateStatusMessage("Disk Label: "..diskLabel)
        else
            updateStatusMessage("Exited.")
        end
    end
end

local function optionGetDiskLabel()
    if hasDisk() then
        if drive.getDiskLabel() ~= nil then
            updateStatusMessage("Disk Label: "..drive.getDiskLabel())
        else
            updateStatusMessage("None")
        end
    end
end

local function optionGetDiskId()
    if hasDisk() then
        updateStatusMessage("Disk Id: "..drive.getDiskID())
    end
end

local function optionGetMountPath()
    if hasDisk() then
        updateStatusMessage("Mount Path: "..drive.getMountPath())
    end
end

local function optionCopyToDiskPath()
    if hasDisk() then
        updateStatusMessage("Insert Source to Copy:")
        source = readAtPos(25, 2)
        if source ~= "" then
            shell.run("copy", source, drive.getMountPath())
            updateStatusMessage("Copied!")
        else
            updateStatusMessage("Exited.")
        end
    end
end

local function optionCopyDiskToFolder()
    if hasDisk() then
        updateStatusMessage("Insert Destination:")
        source = readAtPos(25, 2)
        if source ~= "" then
            shell.run("copy", drive.getMountPath(), source)
            updateStatusMessage("Copied!")
        else
            updateStatusMessage("Exited.")
        end
    end
end

local function optionPrintDiskContent()
    if hasDisk() then
        resetScreen()
        term.setCursorPos(1, 1)
        term.setTextColor(colors.blue)
        printAtPos(1, 1, "Disk Content:")
        term.setTextColor(colors.white)
        term.setCursorPos(1, 2)
        shell.run("ls", drive.getMountPath())
        readAtPos(1, 19)
    end
end

local function optionDeleteFromDisk()
    if hasDisk() then
        updateStatusMessage("What to delete: ")
        target = readAtPos(25, 2)
        if target ~= "" then
            shell.run("rm", drive.getMountPath().."/"..target)
            updateStatusMessage("Removed!")
        else
            updateStatusMessage("Exited.")
        end
    end
end

local function optionPlayAudio()
    if hasDisk() then
        updateStatusMessage("Playing audio.")
        drive.playAudio()
    end
end

local function optionStopAudio()
    if hasDisk() then
        updateStatusMessage("Audio stopped.")
        drive.stopAudio()
    end
end



resetScreen()
if hasDrive == false then
    term.setTextColor(colors.red)
    printAtPos(
        15, 8,
        "No disk drive available!")
    term.setTextColor(colors.white)
    sleep(1)
    shell.run("myprograms")
 
else
    printAtPos(
        11, 8,
        "Disk drive available, loading."
    )
        sleep(0.3)
    printAtPos(
        11, 8,
        "Disk drive available, loading.."
    )
        sleep(0.3)
    printAtPos(
        11, 8,
        "Disk drive available, loading..."
    )
        sleep(0.3)
end

while switch == true do
    resetScreen()
    drawDiskToolsMenu(menuSelectedOption)
    events = {os.pullEvent()}
    
    --ENTER
    if events[1] == 'key' then
        if events[2] == keyEnter then
            if menuSelectedOption == 1 then
                --eject disk
                optionEjectDisk()

            elseif menuSelectedOption == 2 then
                optionSetDiskLabel()

            elseif menuSelectedOption == 3 then
                optionGetDiskLabel()
            
            elseif menuSelectedOption == 4 then
                --get disk id
                optionGetDiskId()
 
            elseif menuSelectedOption == 5 then
                --get mount path
                optionGetMountPath()

            elseif menuSelectedOption == 6 then
                --copy to disk path
                optionCopyToDiskPath()

            elseif menuSelectedOption == 7 then
               --has data
               optionCopyDiskToFolder()

            elseif menuSelectedOption == 8 then
                --has audio
                optionPrintDiskContent()

            elseif menuSelectedOption == 9 then
                -- format disk 
                optionDeleteFromDisk()

            elseif menuSelectedOption == 10 then
               --play audio
               optionPlayAudio()

            elseif menuSelectedOption == 11 then
                --stop audio
                optionStopAudio()
            
            elseif menuSelectedOption == 12 then
                resetScreen()
                shell.run("fireOs/myprograms.lua")
                break
            end
        --GO UP MENU
        elseif events[2] == keyUp or events[2] == keyW then
            if menuSelectedOption == 1 then
                menuSelectedOption = table.getn(diskToolsMenuOptions)
            
            elseif menuSelectedOption > 1 then
                menuSelectedOption = menuSelectedOption - 1
            end
        --GO DOWN MENU
        elseif events[2] == keyDown or events[2] == keyS then
            if menuSelectedOption == table.getn(diskToolsMenuOptions) then
                menuSelectedOption = 1
            
            elseif menuSelectedOption < table.getn(diskToolsMenuOptions) then
                menuSelectedOption = menuSelectedOption + 1
            end
        end
    end 
end
    