# WordPress IRIS Framework Documentation

## Introduction

The WP IRIS Framework is a RESTful API framework designed to bridge WordPress with InterSystems IRIS. It provides a flexible and extensible architecture for creating custom endpoints that can interact with IRIS data and functionality. The framework follows a convention-based routing system that automatically maps HTTP requests to appropriate class methods.

## How It Works

### Core Architecture

The framework is built around the `Router` class (`WordPressAPI.Framework.Core.Router`), which extends `%CSP.REST`. It handles all incoming HTTP requests and routes them to the appropriate handler classes based on the URL structure.

### URL Structure

The framework uses a consistent URL pattern:
```
/wp/:classname/:method[/:parameter]
```

Where:
- `:classname` - The name of the module/feature (e.g., "fintech")
- `:method` - The resource type (e.g., "transactions")
- `:parameter` - Optional parameter (typically an ID)

### Request Methods

The framework supports the following HTTP methods:

- **GET** - For retrieving data
  - Without parameter: Calls `List()` method
  - With parameter: Calls `GetById()` method

- **POST** - For creating/updating data
  - Without parameter: Calls `Create()` method
  - With parameter: Calls `Update()` method

## Implementing Custom Functionality

### Step 1: Create Your Module Structure

1. Create a new folder in `src/WordPressAPI/Framework/` for your module
2. Create a class file following the naming convention: `WordPressAPI.Framework.[Module].[Resource]`

Example structure:
```
src/WordPressAPI/Framework/
└── Fintech/
    └── Transactions.cls
```

### Step 2: Implement Required Methods

Your class must implement the following methods:

#### For GET Requests

```objectscript
ClassMethod List() As %DynamicObject
{
    // Return a list of items
    // Example:
    Set result = {
        "items": [],
        "total": 0
    }
    return result
}

ClassMethod GetById(id As %String) As %DynamicObject
{
    // Return a single item by ID
    // Example:
    Set result = {
        "id": id,
        "data": {}
    }
    return result
}
```

#### For POST Requests

```objectscript
ClassMethod Create(data As %DynamicObject) As %DynamicObject
{
    // Create a new item
    // Example:
    Set result = {
        "id": "new-id",
        "status": "created"
    }
    return result
}

ClassMethod Update(id As %String, data As %DynamicObject) As %DynamicObject
{
    // Update an existing item
    // Example:
    Set result = {
        "id": id,
        "status": "updated"
    }
    return result
}
```

### Step 3: Response Format

All methods should return a `%DynamicObject` that will be automatically converted to JSON. The response should follow a consistent structure:

```json
{
    "status": "success",
    "data": {
        // Your data here
    }
}
```


## Example Implementation

Here's a complete example of a custom module:

```objectscript
Class WordPressAPI.Framework.Fintech.Transactions Extends (%Persistent, %JSON.Adaptor, %Populate)
{

ClassMethod List() As %DynamicObject
{
    Set result = {
        "status": "success",
        "data": {
            "items": [],
            "total": 0
        }
    }
    return result
}

ClassMethod GetById(id As %String) As %DynamicObject
{
    if '##class(Framework.Fintech).Exists(id) {
        return $$$ERROR($$$GeneralError, "Transaction not found")
    }
    
    Set result = {
        "status": "success",
        "data": {
            "id": id,
            "amount": 100.00,
            "date": $zdate($horolog, 3)
        }
    }
    return result
}

ClassMethod Create(data As %DynamicObject) As %DynamicObject
{
    Set result = {
        "status": "success",
        "data": {
            "id": "new-transaction-id",
            "message": "Transaction created successfully"
        }
    }
    return result
}

ClassMethod Update(id As %String, data As %DynamicObject) As %DynamicObject
{
    if '##class(YourClass).Exists(id) {
        return $$$ERROR($$$GeneralError, "Transaction not found")
    }
    
    Set result = {
        "status": "success",
        "data": {
            "id": id,
            "message": "Transaction updated successfully"
        }
    }
    return result
}

}
```

## Testing Your Implementation

To test your implementation:

1. Start your IRIS instance
2. Access your endpoint using the URL pattern:
   ```
   http://localhost:62773/csp/wpapi/wp/[module]/[resource]/[id]
   ```
3. Use tools like Postman or curl to test different HTTP methods

