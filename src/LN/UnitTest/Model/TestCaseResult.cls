/// Object that contains unit test class info
Class LN.UnitTest.Model.TestCaseResult Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

Property name As %String;

Property description As %String;

Property status As %String [ InitialExpression = "pending" ];

Property datetime As %String;

Property duration As %String;

Property location As %String;

Property action As %String; 

Property counter As %String; 


Storage Default
{
<Data name="TestCaseResultState">
<Value name="1">
<Value>name</Value>
</Value>
<Value name="2">
<Value>description</Value>
</Value>
<Value name="3">
<Value>status</Value>
</Value>
<Value name="4">
<Value>datetime</Value>
</Value>
</Data>
<State>TestCaseResultState</State>
<StreamLocation>^LN.UnitTest4FF5.TestCaseResultS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
