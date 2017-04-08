Class ikra.Dictionary.MarksUnit Extends %Persistent
{

Property DomainID As %Integer;

Property UID As %Integer;

Property UName As %String;

Property CtgID As %Integer;

Property Mark As %Numeric;

Index fkMU On (DomainID, UID, CtgID) [ PrimaryKey, Unique ];

Storage Default
{
<Data name="MarksUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DomainID</Value>
</Value>
<Value name="3">
<Value>UID</Value>
</Value>
<Value name="4">
<Value>UName</Value>
</Value>
<Value name="5">
<Value>CtgID</Value>
</Value>
<Value name="6">
<Value>Mark</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.MarksUnitD</DataLocation>
<DefaultData>MarksUnitDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.MarksUnitD</IdLocation>
<IndexLocation>^ikra.Dictionary.MarksUnitI</IndexLocation>
<StreamLocation>^ikra.Dictionary.MarksUnitS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

