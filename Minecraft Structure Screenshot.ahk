#Requires AutoHotkey v2.0
#SingleInstance Force

^!r:: Reload ; Ctrl+Alt+R

; [length, height, width, centreXdiff, centreYdiff, centreZdiff]
structuresObj := {
    village_savanna: [200, 10, 1, 20, 20],
    mansion: [100, 10, 1, 20, 20],
    desert_pyramid: [10, 10, 1, 20, 20],
    village_desert: [2000, 10, 1, 20, 20],
    igloo: [2000, 10, 1, 20, 20],
    shipwreck: [200, 10, 1, 20, 20],
    village_plains: [230, 10, 1, 20, 20],
    swamp_hut: [200, 10, 1, 20, 20],
    village_taiga: [200, 10, 1, 20, 20],
    shipwreck_beached: [200, 10, 1, 20, 20],
    village_snowy: [200, 10, 1, 20, 20],
    jungle_pyramid: [200, 10, 1, 20, 20],
    pillager_outpost: [13, 20, 13, 7, 10, 7]
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

^r:: ; Ctrl+R
{
    /*

    for structure, value in structuresObj.OwnProps() {

        findStructure(structure)

        scanStructure(structure, value[1], value[2], value[3], value[4], value[5], value[6])

        ;takeScreenshot(structure)
    }
    */

    findStructure("pillager_outpost")
    moveAround("pillager_outpost")
}

findStructure(structure) {
    Sleep 200
    Send "t"
    Sleep 200
    send "/locate structure " structure
    Sleep 1000
    Send "{Enter}"
    Sleep 3000

    RunWait("getCoordinatesFromLog.sh", , 'Hide')
    Sleep 2000

    Send "{Escape}"
    Sleep 200
    Send "t"
    Sleep 200

    coords := FileRead("coords.txt")
    Send "/tp @s " coords "{Enter}"
    Sleep 8000

    Send "{Space}"
    Sleep 200
    Send "{Space}"
}

moveAround(structure){
    coords := %structure%()
    Send "{Escape}"
    Sleep 200

    i := 1

    for coord in coords {
        if(i == 1){
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

takeScreenshot(structure) {
    Send "#{PrintScreen}"
    Sleep 1000
    RunWait("moveScreenshot.sh " structure, , 'Hide')
    Sleep 2000
    Send "{Escape}"
}

scanStructure(structure, length, height, width, centreXdiff, centreYdiff, centreZdiff) {
    SoundBeep width

    ;takeScreenshot(structure)
}

pillager_outpost() {
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

    Loop levels {
        Loop divisions {
            x := centre[1] + radius * Cos(360/12 * i)
            z := centre[3] + radius * Sin(360/12 * i)
            y := centre[2] + ((j - 2) * 10)
            
            string := x " " y " " z

            coords.Push(string)

            i++
        }
        j++
    }

    return coords
}
