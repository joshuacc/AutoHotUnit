#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

Add(a, b) {
    return a + b
}

Multiply(a, b) {
    return a * b
}