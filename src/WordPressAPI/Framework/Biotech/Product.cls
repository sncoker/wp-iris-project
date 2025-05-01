Class WordPressAPI.Framework.Biotech.Product Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Property ProductName As %String(MAXLEN = 200);

// i.e. "Recombinant Human IL-2 Protein"

Property CatalogNumber As %String;

// i.e. "RH-IL2-100"

Property Target As %String;

// i.e. "Interleukin-2"

Property HostSpecies As %String;

// i.e. "Human"

Property Applications As %String;

// i.e. "Flow Cytometry, Immunocytochemistry, Immunohistochemistry, Immunoprecipitation, Western Blot"

Property CitationPMID As %String;

// i.e. "PMID:12345678"

Property ProductClass As WordPressAPI.Framework.Biotech.ProductClass;

ClassMethod %Count() As %Integer
{
    Set count = 0
    Set id = ""
    for {
        Set id = $order(^WAPI.BT.ProductD(id))
        quit:id=""
        Set count = count + 1
    }
    return count
}

ClassMethod List() As %DynamicArray
{
    Set array = []
    Set id = ""
    for {
        Set id = $order(^WAPI.BT.ProductD(id))
        quit:id=""
        Set product = ..%OpenId(id)
        if $isobject(product) {
            Set obj = {
                "id": (id),
                "productName": (product.ProductName),
                "catalogNumber": (product.CatalogNumber),
                "target": (product.Target),
                "hostSpecies": (product.HostSpecies),
                "applications": (product.Applications),
                "citationPMID": (product.CitationPMID),
                "productClass": {
                    "id": ($s($isobject(product.ProductClass):product.ProductClass.%Id(),1:"")),
                    "className": ($s($isobject(product.ProductClass):product.ProductClass.ClassName,1:""))
                }
            }
            Do array.%Push(obj)
        }
    }
    return array
}

ClassMethod Get(id As %String) As %DynamicObject
{
    Set product = ..%OpenId(id)
    if '$isobject(product) return {}
    
    return {
        "id": (id),
        "productName": (product.ProductName),
        "catalogNumber": (product.CatalogNumber),
        "target": (product.Target),
        "hostSpecies": (product.HostSpecies),
        "applications": (product.Applications),
        "citationPMID": (product.CitationPMID),
        "productClass": {
            "id": ($s($isobject(product.ProductClass):product.ProductClass.%Id(),1:"")),
            "className": ($s($isobject(product.ProductClass):product.ProductClass.ClassName,1:""))
        }
    }
}

ClassMethod GetById(id As %Integer) As %DynamicObject
{
    Set product = ..%OpenId(id)
    if '$isobject(product) return {}
    
    return {
        "id": (id),
        "productName": (product.ProductName),
        "catalogNumber": (product.CatalogNumber),
        "target": (product.Target),
        "hostSpecies": (product.HostSpecies),
        "applications": (product.Applications),
        "citationPMID": (product.CitationPMID),
        "productClass": {
            "id": ($s($isobject(product.ProductClass):product.ProductClass.%Id(),1:"")),
            "className": ($s($isobject(product.ProductClass):product.ProductClass.ClassName,1:""))
        }
    }
}

ClassMethod Create(data As %DynamicObject) As %DynamicObject
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        // Validate required fields
        if '$isobject(data) || 'data.%IsDefined("productName") || 'data.%IsDefined("catalogNumber") {
            Set %response.Status = "400 Bad Request"
            Set result = {}
            Set result.error = "Missing required fields: productName and catalogNumber are required"
            return result
        }
        
        // Create new product
        Set product = ..%New()
        Set product.ProductName = data.productName
        Set product.CatalogNumber = data.catalogNumber
        
        // Set optional fields if provided
        if data.%IsDefined("target") Set product.Target = data.target
        if data.%IsDefined("hostSpecies") Set product.HostSpecies = data.hostSpecies
        if data.%IsDefined("applications") Set product.Applications = data.applications
        if data.%IsDefined("citationPMID") Set product.CitationPMID = data.citationPMID
        
        // Handle product class if provided
        if data.%IsDefined("productClass") && data.productClass.%IsDefined("className") {
            Set productClass = ##class(WordPressAPI.Framework.Biotech.ProductClass).%New()
            Set productClass.ClassName = data.productClass.className
            Set product.ProductClass = productClass
        }
        
        // Save the product
        Set tSC = product.%Save()
        if $$$ISERR(tSC) {
            Set %response.Status = "500 Internal Server Error"
            Set result = {}
            Set result.error = "Failed to save product: "_$System.Status.GetErrorText(tSC)
            return result
        }
        
        // Return success with created product
        Set %response.Status = "201 Created"
        Set result = {}
        Set result.id = product.%Id()
        Set result.productName = product.ProductName
        Set result.catalogNumber = product.CatalogNumber
        Set result.target = product.Target
        Set result.hostSpecies = product.HostSpecies
        Set result.applications = product.Applications
        Set result.citationPMID = product.CitationPMID
        Set result.productClass = {}
        Set result.productClass.id = $s($isobject(product.ProductClass):product.ProductClass.%Id(),1:"")
        Set result.productClass.className = $s($isobject(product.ProductClass):product.ProductClass.ClassName,1:"")
        return result
        
    } catch e {
        Set %response.Status = "500 Internal Server Error"
        Set result = {}
        Set result.error = "Server error: "_e.DisplayString()
        return result
    }
}

ClassMethod Update(id As %String, data As %DynamicObject) As %DynamicObject
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        // Check if product exists
        Set product = ..%OpenId(id)
        if '$isobject(product) {
            Set %response.Status = "404 Not Found"
            Set result = {}
            Set result.error = "Product not found with ID: "_id
            return result
        }
        
        // Update fields if provided
        if data.%IsDefined("productName") Set product.ProductName = data.productName
        if data.%IsDefined("catalogNumber") Set product.CatalogNumber = data.catalogNumber
        if data.%IsDefined("target") Set product.Target = data.target
        if data.%IsDefined("hostSpecies") Set product.HostSpecies = data.hostSpecies
        if data.%IsDefined("applications") Set product.Applications = data.applications
        if data.%IsDefined("citationPMID") Set product.CitationPMID = data.citationPMID
        
        // Handle product class update if provided
        if data.%IsDefined("productClass") {
            if data.productClass.%IsDefined("className") {
                if '$isobject(product.ProductClass) {
                    Set productClass = ##class(WordPressAPI.Framework.Biotech.ProductClass).%New()
                    Set product.ProductClass = productClass
                }
                Set product.ProductClass.ClassName = data.productClass.className
            }
        }
        
        // Save the updates
        Set tSC = product.%Save()
        if $$$ISERR(tSC) {
            Set %response.Status = "500 Internal Server Error"
            Set result = {}
            Set result.error = "Failed to update product: "_$System.Status.GetErrorText(tSC)
            return result
        }
        
        // Return updated product
        Set result = {}
        Set result.id = id
        Set result.productName = product.ProductName
        Set result.catalogNumber = product.CatalogNumber
        Set result.target = product.Target
        Set result.hostSpecies = product.HostSpecies
        Set result.applications = product.Applications
        Set result.citationPMID = product.CitationPMID
        Set result.productClass = {}
        Set result.productClass.id = $s($isobject(product.ProductClass):product.ProductClass.%Id(),1:"")
        Set result.productClass.className = $s($isobject(product.ProductClass):product.ProductClass.ClassName,1:"")
        return result
        
    } catch e {
        Set %response.Status = "500 Internal Server Error"
        Set result = {}
        Set result.error = "Server error: "_e.DisplayString()
        return result
    }
}

ClassMethod Delete(id As %String) As %DynamicObject
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        // Check if product exists
        Set product = ..%OpenId(id)
        if '$isobject(product) {
            Set %response.Status = "404 Not Found"
            Set result = {}
            Set result.error = "Product not found with ID: "_id
            return result
        }
        
        // Delete the product
        Set tSC = product.%DeleteId(id)
        if $$$ISERR(tSC) {
            Set %response.Status = "500 Internal Server Error"
            Set result = {}
            Set result.error = "Failed to delete product: "_$System.Status.GetErrorText(tSC)
            return result
        }
        
        // Return success
        Set %response.Status = "204 No Content"
        Set result = {}
        Set result.success = 1
        Set result.message = "Product deleted successfully"
        return result
        
    } catch e {
        Set %response.Status = "500 Internal Server Error"
        Set result = {}
        Set result.error = "Server error: "_e.DisplayString()
        return result
    }
}

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductName</Value>
</Value>
<Value name="3">
<Value>CatalogNumber</Value>
</Value>
<Value name="4">
<Value>Target</Value>
</Value>
<Value name="5">
<Value>HostSpecies</Value>
</Value>
<Value name="6">
<Value>Applications</Value>
</Value>
<Value name="7">
<Value>CitationPMID</Value>
</Value>
<Value name="8">
<Value>ProductClass</Value>
</Value>
</Data>
<DataLocation>^WAPI.BT.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^WAPI.BT.ProductD</IdLocation>
<IndexLocation>^WAPI.BT.ProductI</IndexLocation>
<StreamLocation>^WAPI.BT.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
