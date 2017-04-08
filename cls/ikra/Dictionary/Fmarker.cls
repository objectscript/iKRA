Class ikra.Dictionary.Fmarker Extends %Persistent
{

Property FName As %String;

Property CtgID As %Integer;

Storage Default
{
<Data name="FmarkerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FName</Value>
</Value>
<Value name="3">
<Value>CtgID</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.FmarkerD</DataLocation>
<DefaultData>FmarkerDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.FmarkerD</IdLocation>
<IndexLocation>^ikra.Dictionary.FmarkerI</IndexLocation>
<StreamLocation>^ikra.Dictionary.FmarkerS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

