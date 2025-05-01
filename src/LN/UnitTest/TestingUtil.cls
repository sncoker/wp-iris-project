Include HS.HC.Util

/// Author: Chi Nguyen-Rettig (LEADNorth) 12/11/2024
/// This utility class inspects the TestSuites run for the project UnitTest folders
/// Depedencies:
/// Globals: ^UnitTestRoot - location of the base unit test folder
/// 		 ^UnitTest("PackagePath") - default path to project if none passed in
/// 			 ^UnitTest("Namespace") - default unit test namespace if none passed in
/// Method: BuildTestStatus 
/// Calls BuildProject from LN.UnitTest.ProjectUtil to build a project object
/// Based on the project object, queries the test status table located at: select * from %UnitTest_Result.TestAssert
/// Returns the project object with test statuses updated 
/// Run: do ##class(LN.UnitTest.TestingUtil).BuildTestStatus("EG","EGMUSC","BCBSSC", .projectObj)
Class LN.UnitTest.TestingUtil Extends %RegisteredObject
{

ClassMethod BuildTestStatus(projectName As %String, namespace As %String = "", packagePath As %String = "", ByRef projectObj As LN.UnitTest.Model.Project) As %Status
{
	
	#dim namespaceObj As LN.UnitTest.Model.Namespace
	
	Set tStatus = $$$OK
	try {

	if projectName = "" {
			$$$ThrowError($$$GeneralError,"Project Name required")
	}

	//if namespace is empty
	if namespace ="" {
		set tNamespace = $GET(^UnitTest("Namespace"))
		if tNamespace = "" {
			
			$$$ThrowError($$$GeneralError,"Namespace parameter required or set ^UnitTest(""Namespace"")")
		}	
	}	
	else {
		set tNamespace = namespace	
	}

	//if package path is empty
	if packagePath ="" {
		set tPackagePath = $GET(^UnitTest("PackagePath"))
		if tPackagePath = "" {
			
			$$$ThrowError($$$GeneralError,"PackagePath parameter required or set ^UnitTest(""PackagePath"")")
		}	
	}	
	else {
		set tPackagePath = packagePath	
	}
	#dim classList As List of LN.UnitTest.Model.UnitTestClass
	
	//Call BuildProject
	$$$ThrowOnError(##class(LN.UnitTest.ProjectUtil).BuildProject(projectName,namespace,packagePath,.projectObj))
	set classList = projectObj.Namespace.UnitTestClasses
	
	
	//Loop through the Unit Test cases
	#dim unitTestObj As LN.UnitTest.Model.UnitTestClass
	#dim testCaseObj As LN.UnitTest.Model.TestCase
	#dim testCaseResultObj As LN.UnitTest.Model.TestCaseResult
	For index=1:1:classList.Count() {
		
		Set unitTestObj = classList.GetAt(index)
		//loop through test cases. For each test case, create and add results
		For testIndex=1:1:unitTestObj.testCaseList.Count(){
			Set testCaseObj = unitTestObj.testCaseList.GetAt(testIndex)
			Set classname = unitTestObj.name
			Set testcasename = testCaseObj.name
			&sql(DECLARE C1 CURSOR FOR
 			SELECT t.Action, t.Description, t.Status, i.Duration, t.Location, t.Counter, i.DateTime
 			INTO :action,:description, :status, :duration, :location, :counter, :datetime
			FROM %UnitTest_Result.TestAssert t, %UnitTest_Result.TestInstance i  
			WHERE t.TestMethod [  :classname AND t.TestMethod [ :testcasename AND
			i.ID = $EXTRACT(t.TestMethod, 0, 1) 
			ORDER BY i.datetime

    		)
			
			&sql(OPEN C1)
      			QUIT:(SQLCODE'=0)	
			
			//process cursor
 			&sql(FETCH C1)
	 		While (SQLCODE = 0) {
		 		Set testCaseResultObj = ##class(LN.UnitTest.Model.TestCaseResult).%New()
			 	set testCaseResultObj.name = testcasename
			 	set testCaseResultObj.description = description
			 	set testCaseResultObj.datetime = datetime
				set testCaseResultObj.duration = duration
				set testCaseResultObj.action = action
				set testCaseResultObj.location = location
				set testCaseResultObj.counter = counter

			 	Set testCaseResultObj.status = $SELECT(status=1:"Passed", status=0:"Failed", 1:"Unknown")
			 	//set testCaseResultObj.status = status
			 	do unitTestObj.testCaseList.Insert(testCaseResultObj)
		 		
    			&sql(FETCH C1)
	 		}    
	 	
 			&sql(CLOSE C1)
		}
		
	  }
	}
	catch(ex) {
		w ex.Status	
	}
	Quit tStatus
}

ClassMethod RunUnitTest(projectName As %String, namespace As %String = "", packagePath As %String = "", ByRef projectObj As LN.UnitTest.Model.Project, targetClassName As %String = "*") As %Status
{
	#dim namespaceObj As LN.UnitTest.Model.Namespace
	
	Set tStatus = $$$OK
	try {

	if projectName = "" {
			$$$ThrowError($$$GeneralError,"Project Name required")
	}

	//if namespace is empty
	if namespace ="" {
		set tNamespace = $GET(^UnitTest("Namespace"))
		if tNamespace = "" {
			
			$$$ThrowError($$$GeneralError,"Namespace parameter required or set ^UnitTest(""Namespace"")")
		}	
	}	
	else {
		set tNamespace = namespace	
	}

	//if package path is empty
	if packagePath ="" {
		set tPackagePath = $GET(^UnitTest("PackagePath"))
		if tPackagePath = "" {
			
			$$$ThrowError($$$GeneralError,"PackagePath parameter required or set ^UnitTest(""PackagePath"")")
		}	
	}	
	else {
		set tPackagePath = packagePath	
	}
	
	//Set namespace and ^UnitTestRoot base directory if not set
	Set originalNS = $namespace //set namespace back at the end
	zn tNamespace
	set ^zStatus = "change namespace"
	if ($DATA(^UnitTestRoot) = 0) || (^UnitTestRoot = "")  {
		set ^zStatus = "no ^UnitTestRoot"
		//create the directory and then set the global
		set ^UnitTestRoot = $GET(^UnitTest("TestDirectory"))
		if ($DATA(^UnitTestRoot) = 0) || (^UnitTestRoot = "") {
			set ^zStatus = "still no ^UnitTestRoot"
			$$$ThrowError($$$GeneralError,"^UnitTestRoot needs to be defined")
		}
	}
	set ^zStatus = "something wrong with unittest check"
	If '##class(%File).DirectoryExists($GET(^UnitTestRoot)) {
		set ^zStatus = "creating directory"
		Set tStatus = ##class(%File).CreateDirectory($GET(^UnitTestRoot))
				Quit:($$$ISERR(tStatus))
	}	
		
	#dim classList As List of LN.UnitTest.Model.UnitTestClass
	
	//Call BuildProject
	$$$ThrowOnError(##class(LN.UnitTest.ProjectUtil).BuildProject(projectName,namespace,packagePath,.projectObj))
	set classList = projectObj.Namespace.UnitTestClasses
	
	#dim classObj As %Dictionary.ClassDefintion
	//Loop through the Unit Test cases
	#dim unitTestObj As LN.UnitTest.Model.UnitTestClass
	#dim testCaseObj As LN.UnitTest.Model.TestCase
	#dim testCaseResultObj As LN.UnitTest.Model.TestCaseResult
	if targetClassName = "*" {
		For index=1:1:classList.Count() {
			Set unitTestObj = classList.GetAt(index)
			Set className = unitTestObj.name 
			set tStatus = ..RunSingleTest(className)
			Quit:($$$ISERR(tStatus))	
		}
	}
	else {
		//single test run
		set tStatus = ..RunSingleTest(targetClassName)
		Quit:($$$ISERR(tStatus))	
	}
	//return to previous namespace
	zn originalNS
	
	//update the projectObj with the test statuses
	//$$$ThrowOnError(##class(LN.UnitTest.TestingUtil).BuildTestStatus(projectName,namespace,packagePath,.projectObj))
	
	}
	catch(ex) {
		w ex.Status	
	}
	Quit tStatus
}

/// Helper method: Run Single Unit Test
/// Inspect the class using %Dictionary and get the TestSuite property
/// Check to see if that folder exists beneath ^UnitTestRoot and if it doesn't, 
/// create it programmatically
ClassMethod RunSingleTest(className As %String) As %Status
{
	Set tStatus = $$$OK			
	Set classObj = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	if $IsObject(classObj) {
		Set testSuite = ..GetParameterValue(className,"TestSuite")
		Set testDirectory = ^UnitTestRoot_"/"_testSuite
			
		//create TestSuite sub-folder
		If '##class(%File).DirectoryExists(testDirectory) {
			Set tStatus = ##class(%File).CreateDirectory(testDirectory)
			Quit:($$$ISERR(tStatus))
		}
	
		//Finally run unit tests using a dynamic call
		do $ZOBJCLASSMETHOD(className,"Debug")
	}
	Quit tStatus
}

/// Helper method: Returns the value of the class Parameter
ClassMethod GetParameterValue(className As %String, parameterName As %String) As %String
{
	set returnValue = ""
	
	set classObj = ##class(%Dictionary.ClassDefinition).%OpenId(className)
	if $IsObject(classObj) {
		// get list of properties
 		Set propCount = classObj.Parameters.Count()
 		For i = 1:1:propCount {
     		if classObj.Parameters.GetAt(i).Name = parameterName {
	      	set returnValue = classObj.Parameters.GetAt(i).Default		
     		}
    	}
	}
	quit returnValue
}

}
