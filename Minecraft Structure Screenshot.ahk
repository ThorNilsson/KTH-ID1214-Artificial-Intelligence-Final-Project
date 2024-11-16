#Requires AutoHotkey v2.0
#SingleInstance Force

^!r:: Reload ; Ctrl+Alt+R

structures := [
    "village_savanna",
    "mansion",
    "desert_pyramid",
    "village_desert",
    "igloo",
    "shipwreck",
    "village_plains",
    "swamp_hut",
    "village_taiga",
    "shipwreck_beached",
    "village_snowy",
    "jungle_pyramid",
    "pillager_outpost",
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
]

^r:: ; Ctrl+R
{
    for structure in structures {
        findStructure(structure)

        takeScreenshot(structure)
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
