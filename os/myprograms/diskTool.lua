
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
end

function diskType()
    if drive.hasData() then
        return "floppy"
    elseif drive.hasAudio() then
        return "musicdisk"
    else
        updateStatusMessage("No disk in drive!")
    end
end

function updateStatusMessage(message)
    term.setTextColor(colors.green)
    overwriteAtPos(25, 1, "                                 ")
    overwriteAtPos(25, 1, message)
    statusMessage = message
    term.setTextColor(colors.white)
end

function optionEjectDisk()
    if diskType() == "floppy" or diskType() == "musicdisk" then
        drive.ejectDisk()
        updateStatusMessage("Disk Ejected!")
    end
end

function optionSetDiskLabel()
    if diskType() == "floppy" then
        updateStatusMessage("Insert Disk Label:")
        diskLabel = readAtPos(25, 2)
        if diskLabel ~= "" then
            drive.setDiskLabel(diskLabel)
            updateStatusMessage("Disk Label: "..diskLabel)
        else
            updateStatusMessage("Exited.")
        end
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy disk!")
    end
end

function optionGetDiskLabel()
    if diskType() then
        if drive.getDiskLabel() ~= nil then
            updateStatusMessage("Disk Label: "..drive.getDiskLabel())
        else
            updateStatusMessage("None")
        end
    end
end

function optionGetDiskId()
    if diskType() == "floppy" then
        updateStatusMessage("Disk Id: "..drive.getDiskID())
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Music disks have no ID!")
    end
end

function optionGetMountPath()
    if diskType() == "floppy" then
        updateStatusMessage("Mount Path: "..drive.getMountPath())
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy!")
    end
end

function optionCopyToDiskPath()
    if diskType() == "floppy" then
        updateStatusMessage("Insert Source to Copy:")
        source = readAtPos(25, 2)
        if source ~= "" then
            shell.run("copy", source, drive.getMountPath())
            updateStatusMessage("Copied!")
        else
            updateStatusMessage("Exited.")
        end
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy!")
    end
end

function optionCopyDiskToFolder()
    if diskType() == "floppy" then
        updateStatusMessage("Insert Destination:")
        source = readAtPos(25, 2)
        if source ~= "" then
            shell.run("copy", drive.getMountPath(), source)
            updateStatusMessage("Copied!")
        else
            updateStatusMessage("Exited.")
        end
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy!")
    end
end

function optionPrintDiskContent()
    if diskType()  == "floppy" then
        resetScreen()
        term.setCursorPos(1, 1)
        term.setTextColor(colors.blue)
        printAtPos(1, 1, "Disk Content:")
        term.setTextColor(colors.white)
        term.setCursorPos(1, 2)
        shell.run("ls", drive.getMountPath())
        readAtPos(1, 19)
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy!")
    end
end

function optionDeleteFromDisk()
    if diskType() == "floppy" then
        updateStatusMessage("What to delete: ")
        target = readAtPos(25, 2)
        if target ~= "" then
            shell.run("rm", drive.getMountPath().."/"..target)
            updateStatusMessage("Removed!")
        else
            updateStatusMessage("Exited.")
        end
    elseif diskType() == "musicdisk" then
        updateStatusMessage("Disk is not floppy!")
    end
end

function optionPlayAudio()
    if diskType() == "musicdisk" then
        updateStatusMessage("Playing audio.")
        drive.playAudio()
    elseif diskType() == "floppy" then
        updateStatusMessage("Cannot play floppy disk!")
    end
end

function optionStopAudio()
    if diskType() == "musicdisk" then
        updateStatusMessage("Audio stopped.")
        drive.stopAudio()
    elseif diskType() == "floppy" then
        updateStatusMessage("Cannot play floppy disk!")
    end
end


require("/os/global/variables")

require("/os/menutools")

menuSelectedOption = 1
switch = true
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

-- checks for disk drive
if peripheral.find("drive") ~= nil then
    for i=1, 4 do
        if peripheral.getType(peripheralPositions[i]) == "drive" then
            hasDrive = true
            updateStatusMessage('Drive at position: '..peripheralPositions[i])
            drive = peripheral.wrap(peripheralPositions[i])
        end
    end
    
    peripheralsList = peripheral.getNames()
    for i=1, table.getn(peripheralsList) do
        isDrive, _ = string.find(peripheralsList[i], "drive")
        if isDrive == 1 then
            hasDrive = true
            updateStatusMessage('Drive connected v/ network!')
            drive = peripheral.wrap(peripheralsList[i])
        end
    end

else
    updateStatusMessage("Not found!")
    hasDrive = false
end


resetScreen()
if hasDrive == false then
    term.setTextColor(colors.red)
    printAtPos(
        15, 8,
        "No disk drive available!")
    term.setTextColor(colors.white)
    readAtPos(1, 19)
    shell.run("os/myprograms")
 
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
                shell.run("os/myprograms.lua")
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
    