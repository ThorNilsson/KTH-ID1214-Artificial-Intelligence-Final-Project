#Requires AutoHotkey v2.0
#SingleInstance Force

^!r:: Reload ; Ctrl+Alt+R

structures := [
    "shipwreck"
]

^r::
{
    Send "t"
    Sleep 100
    send "/locate structure "
    send structures[1]
    Send "{Enter}"
    Sleep 500

    /* tail -50  "C:\Users\thor7\AppData\Roaming\.minecraft\logs\latest.log" | grep "The nearest minecraft" | tail -1 */
    /* tail -50  "C:\Users\thor7\AppData\Roaming\.minecraft\logs\latest.log" | grep "The nearest minecraft" | tail -1 */

    /*
    Send "t"
    Click("Right", -900, 1200)
    Sleep 100
    Send "{Enter}" */

    /*   logFile := "C:\Users\thor7\AppData\Roaming\.minecraft\logs\latest.log"
      logContent := ""
      FileRead(logContent, %logFile%)
      if InStr(logContent, "Located shipwreck at") {
          coords := []
          RegExMatch(logContent, "Located shipwreck at \[(-?\d+), (-?\d+), (-?\d+)\]", coords)
          x := coords[1]
          y := coords[2]
          z := coords[3]
          MsgBox "Shipwreck located at: " x ", " y ", " z
      }
      else {
          MsgBox "Shipwreck location not found in the log."
    } */
    /*  send "#minecraft:shipwreck" */
}
/* #t / locate structureollebolle */

/* "/ locate structure#minecraft:shipwreck{Enter}" */
