Class WordPressAPI.Framework.Biotech.ProductClass Extends (%Persistent, %JSON.Adaptor)
{

Property CID As %Integer;

// Class ID

Property ClassName As %String;

// Class Name

ClassMethod %Count() As %Integer
{
    set count = 0
    set id = ""
    for {
        set id = $order(^WAPI.BT.ProductClassD(id))
        quit:id=""
        set count = count + 1
    }
    return count
}

Storage Default
{
<Data name="ProductClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CID</Value>
</Value>
<Value name="3">
<Value>ClassName</Value>
</Value>
</Data>
<DataLocation>^WAPI.BT.ProductClassD</DataLocation>
<DefaultData>ProductClassDefaultData</DefaultData>
<IdLocation>^WAPI.BT.ProductClassD</IdLocation>
<IndexLocation>^WAPI.BT.ProductClassI</IndexLocation>
<StreamLocation>^WAPI.BT.ProductClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
