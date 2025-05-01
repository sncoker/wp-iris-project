Class WordPressAPI.Framework.Core.Router Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/wp/:classname/:method" Method="GET" Call="GetClass" />
    <Route Url="/wp/:classname/:method/:parameter" Method="GET" Call="GetClass" />
    <Route Url="/wp/:classname/:method" Method="POST" Call="PostClass" />
    <Route Url="/wp/:classname/:method/:parameter" Method="POST" Call="PostClass" />
    <!-- Pagination is not yet implemented -->
    <!-- <Route Url="/wp/:classname/:method/page/:page/size/:size" Method="GET" Call="GetClass" /> -->
</Routes>
}

/// This method returns the class text for the named class
ClassMethod GetClass(pClassname As %String, pMethod As %String, pParameter As %String = "") As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        // Handle singular/plural forms
        Set className = "WordPressAPI.Framework."_$zconvert(pClassname, "W")_"."_$zconvert($case(pMethod, "products":"Product", :pMethod), "W")
        
        // Check if the class exists
        if '##class(%Dictionary.ClassDefinition).%ExistsId(className) {
            Return ..SendHttpError(404, "Class not found")
        }
        
        // Set the response type to JSON
        Set %response.ContentType = ..#CONTENTTYPEJSON
        
        // Determine the method to call based on the parameter
        if pParameter = "" {
            // If no parameter, call List() method
            Set result = $classmethod(className, "List")
        } else {
            // If parameter exists, call GetById() method
            Set result = $classmethod(className, "GetById", pParameter)
        }
        
        // Write the JSON response
        if $isobject(result) {
            write result.%ToJSON()
        } else {
            write result
        }
        
    } catch e {
        Set tSC = e.AsStatus()
        do ..Log("Error in GetClass: "_$System.Status.GetErrorText(tSC))
        Return ..SendHttpError(500, "Internal server error")
    }
    
    return tSC
}

/// Handle POST requests
ClassMethod PostClass(pClassname As %String, pMethod As %String, pParameter As %String = "") As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        // Handle singular/plural forms
        Set className = "WordPressAPI.Framework."_$zconvert(pClassname, "W")_"."_$zconvert($case(pMethod, "products":"Product", :pMethod), "W")
        
        // Check if the class exists
        if '##class(%Dictionary.ClassDefinition).%ExistsId(className) {
            Return ..SendHttpError(404, "Class not found")
        }
        
        // Set the response type to JSON
        Set %response.ContentType = ..#CONTENTTYPEJSON
        
        // Get the request body
        Set body = %request.Content.Read()
        Set data = {}.%FromJSON(body)
        
        // Determine the method to call based on the parameter
        if pParameter = "" {
            // If no parameter, call Create() method
            Set result = $classmethod(className, "Create", data)
        } else {
            // If parameter exists, call Update() method
            Set result = $classmethod(className, "Update", pParameter, data)
        }
        
        // Write the JSON response
        if $isobject(result) {
            write result.%ToJSON()
        } else {
            write result
        }
        
    } catch e {
        Set tSC = e.AsStatus()
        Do ..Log("Error in PostClass: "_$System.Status.GetErrorText(tSC))
        Return ..SendHttpError(500, "Internal server error")
    }
    
    return tSC
}

ClassMethod WriteResponse(data As %DynamicObject)
{
        write data.%ToJSON()
}

ClassMethod Log(message As %String)
{
        Set logFile = "/home/irisowner/dev/logs/router.log"
        open logFile:("AW"):10
        if $test {
            use logFile
            write $zdatetime($horolog,3,1,3)," ",message,!
            close logFile
        }
}

/// Send standardized HTTP error with JSON body
ClassMethod SendHttpError(statusCode As %Integer, message As %String) As %Status
{
    Set %response.Status = statusCode
    Do %response.SetHeader("Content-Type", "application/json")
    Set errorObj = {}
    Set errorObj.error = message
    Write errorObj.%ToJSON()
    Return $$$ERROR($$$GeneralError, message)
}

ClassMethod ValidatePagination(pPage As %Integer, pSize As %Integer) As %Status
{
    if pPage < 1 {
        return $$$ERROR($$$GeneralError, "Page number must be greater than 0")
    }
    if pSize < 1 || pSize > 100 {
        return $$$ERROR($$$GeneralError, "Page size must be between 1 and 100")
    }
    return $$$OK
}

ClassMethod AddPaginationHeaders(pPage As %Integer, pSize As %Integer, pTotal As %Integer)
{
    Set %response.Headers("X-Total-Count") = pTotal
    Set %response.Headers("X-Page-Size") = pSize
    Set %response.Headers("X-Current-Page") = pPage
    Set %response.Headers("X-Total-Pages") = $case(pTotal#pSize, 0:pTotal\pSize, :pTotal\pSize+1)
}

}
