#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
#Warn

; Include AutoHotUnit. The path will be different on your system.
#Include, %A_ScriptDir%\..\AutoHotUnit.ahk

; Include each test file
; See individual test files for more information
#Include, %A_ScriptDir%\math.test.ahk

; Run all test suites
ahu.RunSuites()

; To execute all tests from the command line, use the following command:
; autohotkey tests.ahk | echo
; The echo is required in order to print output to the terminal.