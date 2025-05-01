Include HS.HC.Util

/// This method will return the existing class structure underneath a <Project> package and return a UnitTestProject Object
Class LN.UnitTest.ProjectUtil Extends %RegisteredObject
{

ClassMethod BuildProject(projectName As %String, namespace As %String = "", packagePath As %String = "", ByRef projectObj As LN.UnitTest.Model.Project) As %Status
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
	

	//given the project name and package path, inspect all the UnitTest classes underneath it
	Set projectObj = ##class(LN.UnitTest.Model.Project).%New()
	Set namespaceObj = ##class(LN.UnitTest.Model.Namespace).%New()
	
	Set projectObj.Name = projectName
	Set namespaceObj.Name = tNamespace
	
	Set tPackagePath = tPackagePath_"."_projectName_".UnitTest"
	
	Set classList = ..GetClassesInPackage(tPackagePath)
	
	//instantiate UnitTestClass
	#dim unitTestObj As LN.UnitTest.Model.UnitTestClass
	For index=1:1:classList.Count() {
		Set tCurrentClass = classList.GetAt(index)
		
		Set unitTestObj = ##class(LN.UnitTest.Model.UnitTestClass).%New()
        set unitTestObj.name = tCurrentClass
        //w "Opening class : "_tCurrentClass,!
        $$$ThrowOnError(..AddTestCasesToClass( tCurrentClass , tNamespace, unitTestObj))
    	//insert the unitTestObj into the namespace object
    	do namespaceObj.UnitTestClasses.Insert(unitTestObj)    
    }
	
	Set projectObj.Namespace = namespaceObj
	
	}
	catch(ex) {
		w ex.Status	
	}
	Quit tStatus
}

ClassMethod AddTestCasesToClass(className As %String, namespace As %String = "", ByRef unitTest As LN.UnitTest.Model.UnitTestClass) As %Status
{
	Set tStatus = $$$OK
    
    // Prepare the UnitTestClass
    Set unitTest.name = className

	
    // Switch to the specified namespace
    //Set currentNamespace = $namespace
    //If (namespace '= currentNamespace) {
    //    zn namespace
    //}
    #dim testCase As LN.UnitTest.Model.TestCase
	#dim classObj As %Dictionary.ClassDefintion
    // Use %Dictionary to find classes
    Try {
		set classObj = ##class(%Dictionary.ClassDefinition).%OpenId(className)	    
	    // Iterate through the methods
        
        For int=1:1:classObj.Methods.Count() {
	        Set testCase = ##class(LN.UnitTest.Model.TestCase).%New()
            Set method = classObj.Methods.GetAt(int)
            //w method.Name,!
            if $EXTRACT(method.Name,1,4)="Test" {
	            Set testCase.name = method.Name
	            Do unitTest.testCaseList.Insert(testCase) //add test case to list
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }

    // Return status
    Quit tStatus
}

ClassMethod GetClassesInPackage(packagePath As %String, namespace As %String = "") As %ListOfDataTypes
{
    // Prepare the result list
    Set classList = ##class(%ListOfDataTypes).%New()

    // Switch to the specified namespace
    //Set currentNamespace = $namespace
    //If (namespace '= currentNamespace) {
    //    zn namespace
    //}

    // Use %Dictionary to find classes
    Try {
	    do $System.OBJ.GetPackageList(.classes,packagePath) 
	    
	    //loop through multi-dimensional array
	    Set key=$ORDER(classes(""))
   		While (key'="") {
     			//w key,!
     			Do classList.Insert(key)
     			// Get next subscript 
     			SET key = $ORDER(classes(key))
	   }
	    
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }

    // Return the list of classes
    Quit classList
}

// Given a class name return list of unit test methods

// CNR: See if you can use this to create JSON: %ZEN.Auxiliary.JSONProvider:%WriteJSONFromObject

// CNR: To inspect the test results, use this table in namespace where test was run

// select * from %UnitTest_Result.TestAssert

ClassMethod GetTestMethodsInClass(className As %String, namespace As %String = "") As %ListOfDataTypes
{
    // Prepare the result list
    Set methodList = ##class(%ListOfDataTypes).%New()

    // Switch to the specified namespace
    //Set currentNamespace = $namespace
    //If (namespace '= currentNamespace) {
    //    zn namespace
    //}
	#dim classObj As %Dictionary.ClassDefintion
    // Use %Dictionary to find classes
    Try {
		set classObj = ##class(%Dictionary.ClassDefinition).%OpenId(className)	    
	    // Iterate through the methods
        Set method = ""
        For int=1:1:classObj.Methods.Count() {
            Set method = classObj.Methods.GetAt(int)
            if $EXTRACT(method.Name,1,4)="Test" {
            	Do methodList.Insert(method.Name) // Add the method name to the list
            }
        }
    } Catch ex {
        Write "Error: ", ex.DisplayString(), !
    }

    // Return the list of classes
    Quit methodList
}

}
