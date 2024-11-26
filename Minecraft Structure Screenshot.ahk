#Requires AutoHotkey v2.0
#SingleInstance Force

^!r:: Reload ; Ctrl+Alt+R

; [with, height, layers, centerXdiff, centerYdiff]
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
    pillager_outpost: [200, 10, 1, 20, 20]
}
; Maybe
;"fortress",
/*     "minecraft:ruined_portal",
    "minecraft:ruined_portal_desert",
    "minecraft:ruined_portal_jungle",
    "minecraft:ruined_portal_mountain",
    "minecraft:ruined_portal_nether",
    "minecraft:ruined_portal_ocean",
"minecraft:ruined_portal_swamp", */
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
"minecraft:trail_ruins", */

^r:: ; Ctrl+R
{
    for structure, value in structuresObj.OwnProps() {

        findStructure(structure)

        scanStructure(structure, value[1], value[2], value[3], value[4], value[5])

        ;takeScreenshot(structure)
    }
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
}

takeScreenshot(structure) {
    Send "#{PrintScreen}"
    Sleep 1000
    RunWait("moveScreenshot.sh " structure, , 'Hide')
    Sleep 2000
    Send "{Escape}"
}

scanStructure(structure, with, height, layers, centerXdiff, centerYdiff) {
    SoundBeep with

    ;takeScreenshot(structure)
}
