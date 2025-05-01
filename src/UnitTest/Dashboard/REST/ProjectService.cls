Class UnitTest.Dashboard.REST.ProjectService Extends UnitTest.Dashboard.REST.Service.Base
{

/** Change Log
2024-12-10 - Chi Nguyen-Rettig : Created
2024-12-12 - Chi Nguyen-Rettig : Updated with Test Results 
2024-12-12 - Chi Nguyen-Rettig : Add RunUnitTest 
**/
ClassMethod RunUnitTest(className As %String = "*") As %Status
{
	Set tSC = $$$OK
	#; Quit tSC
	Try {		
		#;Dispatch request to production
		#Dim tResponse as %String

		set ^zStatus = "RunUnitTest()"

		//this method should return a response that is project Object	 	
    	$$$ThrowOnError(##class(LN.UnitTest.TestingUtil).RunUnitTest("InteroperabilityProject", "IRISAPP","INTEROP", .tProjectObj))

		set ^zStatus = "Completed Run"

		//Once we have a Project Object, convert it to JSON

		set tStatus = tProjectObj.%JSONExportToStream(.tResponse)

		If $$$ISERR(tStatus) {
			Set %response.Status = 500
		}

		#;Write output 
		Set %response.ContentType="application/json"
	
		Set %response.Status = 200
		//Do tResponse.OutputToDevice()
		Do %response.SetHeader("Access-Control-Allow-Origin","*")


	} 
	Catch Ex {
		Set tStatus = Ex.AsStatus()
		Set %response = tStatus
		Set %response.Status = 500
		Set tStatus = $$$OK
	}
	Quit tStatus
}

ClassMethod GetProjectInfo() As %Status
{
	Set tSC = $$$OK
	#; Quit tSC
	Try {		
		#;Dispatch request to production
		#Dim tResponse as %String

		//this method should return a response that is project Object	 	
    	$$$ThrowOnError(##class(LN.UnitTest.ProjectUtil).BuildProject("InteroperabilityProject", "IRISAPP","INTEROP", .tProjectObj))
		//Once we have a Project Object, convert it to JSON

		set tStatus = tProjectObj.%JSONExportToStream(.tResponse)

		If $$$ISERR(tStatus) {
			Set %response.Status = 500
		}

		#;Write output 
		Set %response.ContentType="application/json"
	
		Set %response.Status = 200
		Do tResponse.OutputToDevice()
		Set ^zLog="Method called:OutputToDevice"
		Do %response.SetHeader("Access-Control-Allow-Origin","*")


	} 
	Catch Ex {
		Set tStatus = Ex.AsStatus()
		//If $$$TESTMODE zw tSC
		Set %response.Status = 500
		Set tStatus = $$$OK
	}
	Quit tStatus
}

ClassMethod GetTestResults() As %Status
{
	Set tSC = $$$OK
	#; Quit tSC
	Try {		
		#;Dispatch request to production
		#Dim tResponse as %String

		//this method should return a response that is project Object	 	
    	$$$ThrowOnError(##class(LN.UnitTest.TestingUtil).BuildTestStatus("InteroperabilityProject", "IRISAPP","INTEROP", .tProjectObj))
		
		//Once we have a Project Object, convert it to JSON

		set tStatus = tProjectObj.%JSONExportToStream(.tResponse)

		If $$$ISERR(tStatus) {
			Set %response.Status = 500
		}

		#;Write output 
		Set %response.ContentType="application/json"
	
		Set %response.Status = 200
		Do tResponse.OutputToDevice()
		Do %response.SetHeader("Access-Control-Allow-Origin","*")
	} 
	Catch Ex {
		Set tStatus = Ex.AsStatus()
		Set %response.Status = 500
		Set %response = tStatus
		Set tStatus = $$$OK
	}
	Quit tStatus
}

}
