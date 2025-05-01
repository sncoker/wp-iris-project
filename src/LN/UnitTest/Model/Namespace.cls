/// Namespace used to organize groups of UnitTest
Class LN.UnitTest.Model.Namespace Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

Property Name As %String;

Property UnitTestClasses As list Of UnitTestClass;

Storage Default
{
<Data name="NamespaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>UnitTestClasses</Value>
</Value>
</Data>
<Data name="NamespaceState">
<Value name="1">
<Value>Name</Value>
</Value>
<Value name="2">
<Value>UnitTestClasses</Value>
</Value>
</Data>
<DataLocation>^LN.UnitTest.Model.NamespaceD</DataLocation>
<DefaultData>NamespaceDefaultData</DefaultData>
<IdLocation>^LN.UnitTest.Model.NamespaceD</IdLocation>
<IndexLocation>^LN.UnitTest.Model.NamespaceI</IndexLocation>
<State>NamespaceState</State>
<StreamLocation>^LN.UnitTest.Model.NamespaceS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
