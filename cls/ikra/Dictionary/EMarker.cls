Class ikra.Dictionary.EMarker Extends %Persistent
{

Property EName As %String;

Property EValue As %Integer;

Storage Default
{
<Data name="EMarkerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EName</Value>
</Value>
<Value name="3">
<Value>EValue</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.EMarkerD</DataLocation>
<DefaultData>EMarkerDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.EMarkerD</IdLocation>
<IndexLocation>^ikra.Dictionary.EMarkerI</IndexLocation>
<StreamLocation>^ikra.Dictionary.EMarkerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

