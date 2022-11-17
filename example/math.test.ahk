#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1

#Include, %A_ScriptDir%\math.ahk

; Register the test suite with AutoHotUnit
ahu.RegisterSuite(MathSuite)

; Define your test suite, extending from the AutoHotUnitSuite class
class MathSuite extends AutoHotUnitSuite {
    multipliesCorrectly() {
        this.assert.equal(Multiply(5, 3), 15)
    }

    addsCorrectly() {
        this.assert.equal(Add(1, 2), 3)
    }
}