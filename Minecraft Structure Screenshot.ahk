#Requires AutoHotkey v2.0
#SingleInstance Force

^!r:: Reload ; Ctrl+Alt+R

structures := [
    "desert_pyramid",
    "mansion",
    "village_desert",
    "igloo",
    "village_savanna",
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

^r::
{
    takeScreenshot(structures[1])
    ;findStructure(structures[1])

    /*     for structure in structures {
            findStructure(structure)
            Sleep 10000
    } */
}

findStructure(structure) {
    Send "t"
    Sleep 100
    send "/locate structure " structure "{Enter}"
    Sleep 100

    RunWait("getCoordinatesFromLog.sh", , 'Hide')
    Sleep 500

    Send "{Escape}"
    Sleep 100
    Send "t"
    Sleep 100

    coords := FileRead("coords.txt")
    Send "/tp @s " coords "{Enter}"
}

goToLocation(x, y, z) {
    Send "t"
    Sleep 100
    Send "/tp @s " x " " y " " z "{Enter}"
}

rotateCamera(x, y) {
    Send "t"
    Sleep 100
    Send "/tp @s ~ ~ ~ " x " " y "{Enter}"
}

takeScreenshot(structure) {
    Send "{PrintScreen}"
    Sleep 1000
    Click('left', 100, 100)

    ;Move the latest screenshot to the TrainingData folder
    RunWait("moveLatestScreenshotToTrainingData.bat", , 'Hide')

    /*     Sleep 1000
    Send "{Enter}" */

    ;Sleep 1000
    ;Run("explorer.exe C:\Users\thor7\Dev\KTH-ID1214-Artificial-Intelligence-Final-Project\TrainingData")
    ;Sleep 2000
    ;Send "^v"

    ;Take a screenshot of the structure and save it in the TrainingData folder
    ; Assuming the screenshot is copied to the clipboard
    ; Open Paint to paste and save the screenshot
    Run("mspaint.exe")
    Sleep 2000
    Send("^v") ; Paste the screenshot
    Sleep 1000
    Send("^s") ; Save the file
    Sleep 1000

    ; Navigate to the TrainingData folder and save the file with a unique name
    ;Send("{Alt down}f{Alt up}a") ; Open Save As dialog
    ;Sleep 1000
    Send A_WorkingDir "\TrainingData\" structure "\" structure " A_Now.png { Enter }"
    Sleep 2000

    Send("!{F4}") ; Close Paint
    Send("{Enter}")
}
