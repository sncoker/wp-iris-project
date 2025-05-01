/// Directs requests to the appropriate class
Class UnitTest.Dashboard.REST.ServiceMap Extends UnitTest.Dashboard.REST.Service.Base
{

/** Change Log
2024-01-20 - Chi Nguyen-Rettig: initial
2024-12-10 - Chi Nguyen-Rettig : Created
2024-12-12 - Chi Nguyen-Rettig : Updated with Test Results 
2024-12-12 - Chi Nguyen-Rettig : Add RunUnitTest 
**/
Parameter Version = "1.0.0";

/// Enable Cross-origin resource sharing handling.
Parameter HandleCorsRequest = 1;

/// Use Session for REST Services
Parameter UseSession = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/" Method="GET" Call="GetProjectInfo"/>
	<Route Url="/results" Method="GET" Call="GetTestResults"/>
	<Route Url="/runtest" Method="GET" Call="RunUnitTest"/>
	<Route Url="/runtestasync" Method="GET" Call="RunUnitTestAsync"/>
  </Routes>
}

// Asynch call to Run Tests. Otherwise the blocking calls will cause timeouts to API

ClassMethod RunUnitTestAsync()
{
    Job ..RunUnitTest()
    Write {"TaskId" : ($zchild)}.%ToJSON()
    Quit $$$OK
}

// Run Unit Tests

ClassMethod RunUnitTest()
{

	Return ##class(UnitTest.Dashboard.REST.ProjectService).RunUnitTest()
}

// Return project object

ClassMethod GetProjectInfo()
{

	Return ##class(UnitTest.Dashboard.REST.ProjectService).GetProjectInfo()
}

ClassMethod GetTestResults()
{

	Return ##class(UnitTest.Dashboard.REST.ProjectService).GetTestResults()
}

ClassMethod FormatResultsToJSON(pResults As %ListOfDataTypes, Output pJsonString As %String)
{


    // Create a dynamic object for JSON
    set jsonObject = ##class(%DynamicObject).%New()

    // Create a dynamic array to store formatted results
    set jsonArray = ##class(%DynamicArray).%New()

    // Loop through the list and format each item into JSON
    for i=1:1:pResults.Count() {
        set value = pResults.GetAt(i).Value

        // Create a temporary object to hold the value pair
        set tempObj = ##class(%DynamicObject).%New()
        set tempObj.value = value

        // Add the object to the array
        do jsonArray.%Push(tempObj)
    }

    // Convert the array to JSON string
	set pJsonString = jsonArray.%ToJSON()
}

}
