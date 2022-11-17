﻿#NoEnv
#SingleInstance, Force
#Warn
SetBatchLines, -1
FileEncoding, UTF-8

SetWorkingDir %A_ScriptDir%

ahu := new AutoHotUnitManager(new AutoHotUnitCLIReporter())

class AutoHotUnitSuite {
    assert := new AutoHotUnitAsserter()

    ; Executed once before any tests execute
    beforeAll() {
    }

    ; Executed once before each test is executed
    beforeEach() {
    }

    ; Executed once after each test is executed
    afterEach() {
    }

    ; Executed once after all tests have executed
    afterAll() {
    }
}

class AutoHotUnitManager {
    Suite := AutoHotUnitSuite
    suites := []

    __New(reporter) {
        this.reporter := reporter
    }

    RegisterSuite(SuiteSubclasses*)
    {
        for i, subclass in SuiteSubclasses {
            this.suites.push(subclass)
        }
    }

    RunSuites() {
        this.reporter.onRunStart()
        for i, suiteClass in this.suites {
            suiteInstance := new suiteClass()
            suiteName := suiteInstance.__Class
            this.reporter.onSuiteStart(suiteName)
            
            testNames := []
            for propertyName in suiteInstance.base {
                ; If the property name starts with an underscore, skip it
                underScoreIndex := InStr(propertyName, "_")
                if (underScoreIndex == 1) {
                    continue
                }

                ; If the property name is one of the Suite base class methods, skip it
                if (propertyName == "beforeAll" || propertyName == "beforeEach" || propertyName == "afterEach" || propertyName == "afterAll") {
                    continue
                }

                if (IsFunc(suiteInstance[propertyName])) {
                    testNames.push(propertyName)
                }
            }



            try {
                suiteInstance.beforeAll()
            } catch e {
                this.reporter.onTestResult("beforeAll", "failed", e)
                continue
            }

            for j, testName in testNames {
                try {
                    suiteInstance.beforeEach()
                } catch e {
                    this.reporter.onTestResult(testName, "failed", "beforeEach", e)
                    continue
                }

                try {
                    suiteInstance[testName]()
                } catch e {
                    this.reporter.onTestResult(testName, "failed", "test", e)
                    continue
                }

                try {
                    suiteInstance.afterEach()
                } catch e {
                    this.reporter.onTestResult(testName, "failed", "afterEach", e)
                    continue
                }

                this.reporter.onTestResult(testName, "passed", "", "")
            }

            try {
                suiteInstance.afterAll()
            } catch e {
                this.reporter.onTestResult("afterEach", "failed", e)
                continue
            }

            this.reporter.onSuiteEnd(suiteName)
        }
        this.reporter.onRunComplete()
    }
}

class AutoHotUnitCLIReporter {
    currentSuiteName := ""
    failures := []
    red := "[31m"
    green := "[32m"
    reset := "[0m"

    printLine(str) {
        FileAppend, %str%, *, UTF-8
        FileAppend, `r`n, *
    }

    onRunStart() {
        this.printLine("Starting test run`r`n")
    }

    onSuiteStart(suiteName) {
        this.printLine(suiteName ":")
        this.currentSuiteName := suiteName
    }
    
    onTestStart(testName) {
    }

    onTestResult(testName, status, where, error) {
        if (status != "passed" && status != "failed") {
            throw "Invalid status: " . status
        }

        prefix := this.green . "."
        if (status == "failed") {
            prefix := this.red . "x"
        }

        this.printLine("  " prefix " " testName " " status this.reset)
        if (status == "failed") {
            this.printLine(this.red "      " error this.reset)
            this.failures.push(this.currentSuiteName "." testName " " where " failed:`r`n  " error)
        }
    }

    onSuiteEnd(suiteName) {
    }

    onRunComplete() {
        this.printLine("")
        postfix := "All tests passed." 
        if (this.failures.Length() > 0) {
            postfix := this.failures.Length() . " test(s) failed."
        }
        this.printLine("Test run complete. " postfix)

        if (this.failures.Length() > 0) {
            this.printLine("")
        }

        for i, failure in this.failures {
            this.printLine(this.red failure this.reset)
        }

        Exit this.failures.Length()
    }
}

class AutoHotUnitAsserter {
    equal(actual, expected) {
        if (actual != expected) {
            throw "Assertion failed: " . actual . " != " . expected
        }
    }

    notEqual(actual, expected) {
        if (actual == expected) {
            throw "Assertion failed: " . actual . " == " . expected
        }
    }

    isTrue(actual) {
        if (actual != true) {
            throw "Assertion failed: " . actual . " is not true"
        }
    }

    isFalse(actual) {
        if (actual == true) {
            throw "Assertion failed: " . actual . " is not false"
        }
    }

    isEmpty(actual) {
        if (actual != "") {
            throw "Assertion failed: " . actual . " is not empty"
        }
    }

    notEmpty(actual) {
        if (actual == "") {
            throw "Assertion failed: " . actual . " is empty"
        }
    }

    fail(message) {
        throw "Assertion failed: " . message
    }
    
    isAbove(actual, expected) {
        if (actual <= expected) {
            throw "Assertion failed: " . actual . " is not above " . expected
        }
    }

    isAtLeast(actual, expected) {
        if (actual < expected) {
            throw "Assertion failed: " . actual . " is not at least " . expected
        }
    }

    isBelow(actual, expected) {
        if (actual >= expected) {
            throw "Assertion failed: " . actual . " is not below " . expected
        }
    }

    isAtMost(actual, expected) {
        if (actual > expected) {
            throw "Assertion failed: " . actual . " is not at most " . expected
        }
    }
}
