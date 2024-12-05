#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_LOG_SOURCE := getEnv("MINECRAFT_LOG_SOURCE")
SCREENSHOT_SOURCE_DIR := getEnv("SCREENSHOT_SOURCE_DIR")

^!r:: Reload ; Ctrl+Alt+R

; [length, height, width, centreXdiff, centreYdiff, centreZdiff]
structuresObj := {
    mansion: ["mansion", 60, [-22, -5, 10, 25]],
    desert_pyramid: ["desert_pyramid", 16, [-10, -5, 0, 10]],
    igloo: ["igloo", 10, [-2, 0, 4, 10]],
    village_desert: ["village_desert", 16, [-4, 0, 8, 15]],
    village_savanna: ["village_savanna", 16, [-4, 0, 8, 15]],
    village_plains: ["village_plains", 16, [-4, 0, 8, 15]],
    swamp_hut: ["swamp_hut", 14],
    shipwreck: ["shipwreck", 14],
    shipwreck_beached: ["shipwreck_beached", 14],
    village_taiga: ["village_taiga", 16, [-4, 0, 8, 15]],
    village_snowy: ["village_snowy", 16, [-4, 0, 8, 15]],
    jungle_pyramid: ["jungle_pyramid", 14],
    pillager_outpost: ["pillager_outpost", 14, [-16, -12, -8, 0, 8], [0, 10, 20, 30, 50]],
}

; 1. Select the structure
current := structuresObj.village_desert

; 2. Prepare the environment and move to the structure
^g:: ; Ctrl+G
{
    mcCommand("/weather clear")
    mcCommand("/time set day")
    findStructure(current[1])
}

; 3. Take screenshots of the structure
^r:: ; Ctrl+R - Stand on top of the structure
{
    scanStructure(current*)
    MsgBox("Scanning complete")
}

; 4. Place the structure
^i:: ; Ctrl+i
{
    mcCommand("/weather clear")
    mcCommand("/time set day")
    placeStructure(current[1])
}

toggleFlying() {
    Sleep 200
    SendInput "{Space down}"
    Sleep 50
    SendInput "{Space up}"
    Sleep 170
    SendInput "{Space down}"
    Sleep 60
    SendInput "{Space up}"
}

findStructure(structure) {
    time := A_Now

    mcCommand("/locate structure " structure)

    coords := getStructureCoordsFromLog(time)

    teleportTo(coords)
    Sleep 2000

    mcCommand("/gamemode creative")
    Sleep 1000
    toggleFlying()
    Sleep 8000

    mcCommand("/gamemode spectator")
}

placeStructure(structure) {
    mcCommand("/place structure " structure)
}

mcCommand(command) {
    Send "t"
    Sleep 150
    Send command "{Enter}"
    Sleep 150
}

moveScreenshots(structure) {
    DirExist("trainingdata\" structure) || DirCreate("trainingdata\" structure)
    loop files SCREENSHOT_SOURCE_DIR "\*.png" {
        if (FileExist(A_LoopFileFullPath) && DateDiff(A_Now, A_LoopFileTimeCreated, "s") <= 30) {
            FileMove(A_LoopFileFullPath, "trainingdata\" structure "\" A_LoopFileName)
        }
    }
}

scanStructure(structure, radius, levels := [-12, -8, 0, 8], angles := [10, 20, 30, 50], picturesPerLevel := 12) {
    SoundBeep radius
    teleportTo()
    center := StrSplit(getPlayerCoordsFromLog(), " ", OmitChars := "`r`n")
    center := [Round(center[1], 0), Round(center[2], 0), Round(center[3], 0)]

    i := 1
    pi := 3.14159265359

    Send "{F1}"
    Sleep 500
    for index, level in levels {
        loop picturesPerLevel {
            radians := ((360 / picturesPerLevel) * i) * (pi / 180)
            x := center[1] + radius * Cos(radians)
            y := center[3] + radius * Sin(radians)
            z := center[2] + level
            xAngle := radians * (180 / pi) + 90
            yAngle := angles[index]

            teleportTo(x, z, y, xAngle, yAngle)
            Send "{F2}" ; Take a screenshot
            i++
        }
    }
    Send "{F1}"
    teleportTo(center[1], center[2], center[3])
    moveScreenshots(structure)
}

teleportTo(x := "~", z := "~", y := "~", xAngle := 0, yAngle := 0) {
    mcCommand("/tp @s " x "  " z "  " y "  " xAngle " " yAngle)
}

getEnv(key) {
    env := FileRead(".env")
    lines := StrSplit(env, "`n")
    line := ""
    for i, value in lines {
        if (RegExMatch(value, key)) {
            line := value
            break
        }
    }
    value := RegExReplace(line, key "=(.*)", "$1")
    return RegExReplace(value, "`r", "")
}

getPlayerCoordsFromLog() {
    logfile := FileRead(MINECRAFT_LOG_SOURCE)
    lines := StrSplit(logfile, "`n")
    loop {
        line := lines.Pop()
        if (RegExMatch(line, "Teleported")) {
            coords := RegExReplace(line, "^.*to ", "")
            soordsNoComma := RegExReplace(coords, ",", "")
            return soordsNoComma
        }
    }
}

getStructureCoordsFromLog(time) {
    blockHeight := 180

    loop {
        logfile := FileRead(MINECRAFT_LOG_SOURCE)
        lines := StrSplit(logfile, "`n")
        line := lines.Pop()

        loop {
            line := lines.Pop()
            time2 := RegExReplace(line, "(?<=\] ).*", "")
            time2 := RegExReplace(time2, "^.*\[(.*)\].*$", "$1")
            time2 := RegExReplace(time2, ":", "")
            time2 := RegExReplace(A_Now, "\d{6}$", "") time2
            time2 := RegExReplace(time2, "`r", "")
            time2 := RegExReplace(time2, "`n", "")

            diff := DateDiff(time2, time, "Seconds")
            ;MsgBox(diff)

            ; If the the log filet/locate structur has not been updated run the loop again
            if (diff < -2) {
                ;MsgBox("Log file not updated" diff)
                break
            }
            ; If the log file has been updated but the structure has not been located
            if (RegExMatch(line, "Locating element")) {
                ;MsgBox("Structure not yet located")
                break
            }

            if (RegExMatch(line, "The nearest")) {
                coords := RegExReplace(line, "^.*is at", "")
                coords := RegExReplace(coords, "^.*\[(.*)\].*$", "$1")
                coords := RegExReplace(coords, ",", " ")
                coords := RegExReplace(coords, "~", blockHeight)
                return coords
            }
        }
        Sleep 200
    }
}
