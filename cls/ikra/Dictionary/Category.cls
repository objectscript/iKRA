Class ikra.Dictionary.Category Extends %Persistent
{

Property CtgName As %String;

Storage Default
{
<Data name="CategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtgName</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.CategoryD</DataLocation>
<DefaultData>CategoryDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.CategoryD</IdLocation>
<IndexLocation>^ikra.Dictionary.CategoryI</IndexLocation>
<StreamLocation>^ikra.Dictionary.CategoryS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

