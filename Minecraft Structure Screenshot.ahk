#Requires AutoHotkey v2.0
#SingleInstance Force

MINECRAFT_LOG_SOURCE := getEnv("MINECRAFT_LOG_SOURCE")
SCREENSHOT_SOURCE_DIR := getEnv("SCREENSHOT_SOURCE_DIR")

^!r:: Reload ; Ctrl+Alt+R

; [length, height, width, centreXdiff, centreYdiff, centreZdiff]
structuresObj := {
    village_savanna: ["pillager_outpost", 14],
    mansion: ["mansion", 60, [-22, -5, 10, 25]],
    desert_pyramid: ["desert_pyramid", 16, [-10, -5, 0, 10]],
    village_desert: ["village_desert", 16, [-4, 0, 8, 15]],
    igloo: ["igloo", 10, [-2, 0, 4, 10]],
    ;Todo - Add the rest of the structures
    shipwreck: ["shipwreck", 14],
    village_plains: ["village_plains", 14],
    swamp_hut: ["swamp_hut", 14],
    village_taiga: ["village_taiga", 14],
    shipwreck_beached: ["shipwreck_beached", 14],
    village_snowy: ["village_snowy", 14],
    jungle_pyramid: ["jungle_pyramid", 14],
    pillager_outpost: ["pillager_outpost", 14],
}
; Maybe
;"fortress",
/*     "minecraft:ruined_portal",
    "minecraft:ruined_portal_desert",
    "minecraft:ruined_portal_jungle",
    "minecraft:ruined_portal_mountain",
    "minecraft:ruined_portal_nether",
    "minecraft:ruined_portal_ocean",
"minecraft:ruined_portal_swamp",
*/
; Not Now
/*     "minecraft:ancient_city",
    "minecraft:monument",
    "minecraft:bastion_remnant",
    "minecraft:buried_treasure",
    "minecraft:end_city",
    "minecraft:mineshaft",
    "minecraft:mineshaft_mesa",
    "minecraft:nether_fossil",
    "minecraft:ocean_ruin_cold",
    "minecraft:ocean_ruin_warm",
    "minecraft:stronghold",
"minecraft:trail_ruins",
*/

; 1. Select the structure
current := structuresObj.igloo

; 2. Prepare the environment and move to the structure
^g:: ; Ctrl+G
{
    Send "t"
    Sleep 200
    Send "/weather clear {Enter}"
    Sleep 200
    Send "t"
    Sleep 200
    Send "/time set day {Enter}"
    Sleep 200

    findStructure(current[1])
}

; 3. Take screenshots of the structure
^r:: ; Ctrl+R - Stand on top of the structure
{
    scanStructure(current*)
    MsgBox("Scanning complete")
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
    Sleep 1000
    Send "t"
    Sleep 400
    time := A_Now
    Sleep 400
    send "/locate structure " structure "{Enter}"
    coords := getStructureCoordsFromLog(time)
    ;MsgBox(structure " " coords)

    Sleep 500
    Send "t"
    Sleep 200
    Send "/tp @s " coords "{Enter}"

    Sleep 200
    Send "t"
    Sleep 200
    Send "/gamemode creative {Enter}"

    toggleFlying()

    Sleep 8000

    Sleep 200
    Send "t"
    Sleep 200
    Send "/gamemode spectator {Enter}"
    Sleep 200

}

takeScreenshot(structure) {
    Send "#{PrintScreen}"
    Sleep 1000
    RunWait("moveScreenshot.sh " structure, , 'Hide')
    Sleep 2000
    Send "{Escape}"
}

moveScreenshots(structure) {
    DirExist("TrainingData\" structure) || DirCreate("TrainingData\" structure)
    loop files SCREENSHOT_SOURCE_DIR "\*.png" {
        if (DateDiff(A_Now, A_LoopFileTimeCreated, "s") <= 5) {
            FileMove A_LoopFileFullPath, "TrainingData\" structure "\" A_LoopFileName
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

    for index, level in levels {
        loop picturesPerLevel {
            radians := ((360 / picturesPerLevel) * i) * (pi / 180)
            x := center[1] + radius * Cos(radians)
            y := center[3] + radius * Sin(radians)
            z := center[2] + level
            xAngle := radians * (180 / pi) + 90
            yAngle := angles[index]

            teleportTo(x, z, y, xAngle, yAngle)
            Send "{F1}"
            Sleep 200
            Send "#{PrintScreen}"
            Sleep 500
            Send "{F1}"
            moveScreenshots(structure)
            i++
        }
    }
    teleportTo(center[1], center[2], center[3])
}

teleportTo(x := "~", z := "~", y := "~", xAngle := 0, yAngle := 0) {
    Send "t"
    Sleep 100
    Send "/tp @s " x "  " z "  " y "  " xAngle " " yAngle "{Enter}"
    Sleep 200
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

getCoords() {
    Send "t"
    Sleep 200
    Send "/tp @s ~  ~  ~ {Enter}"
    Sleep 10000

    RunWait("getPlayerCoordinatesFromLog.sh", , 'Hide')
    Sleep 2000

    inputCoords := Trim(FileRead("coords.txt"), OmitChars := "{A_Space}")
    centre := StrSplit(inputCoords, ",", OmitChars := " ")
    centre[3] := Trim(centre[3], OmitChars := "`r`n")

    coords := []

    radius := 25
    divisions := 12
    levels := 1

    width := 13
    height := 20
    length := 13

    centre[1] := centre[1] + (length / 2)
    centre[2] := centre[2] + (height / 2)
    centre[3] := centre[3] + (width / 2)

    centreCoords := centre[1] " " centre[2] " " centre[3]
    coords.Push(centreCoords)
    MSgBox("Centre: " centreCoords)

    i := 1
    j := 1

    loop levels {
        loop divisions {
            x := centre[1] + radius * Cos(360 / 12 * i)
            z := centre[3] + radius * Sin(360 / 12 * i)
            y := centre[2] + ((j - 2) * 10)

            string := x " " y " " z

            coords.Push(string)

            i++
        }
        j++
    }

    return coords
}

moveAround(structure) {
    coords := %structure%()
    Send "{Escape}"
    Sleep 200

    i := 1

    for coord in coords {
        if (i == 1) {
            i := 0
            continue
        }
        Send "t"
        Sleep 200
        Send "/tp @s " coord " facing " coords[1] "{Enter}"
        Sleep 8000
        takeScreenshot(structure)
    }
}
