Class ikra.Dictionary.Domains Extends %Persistent
{

Property dmnName As %String;

Index indDmnNm On dmnName [ Unique ];

Storage Default
{
<Data name="DomainsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dmnName</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.DomainsD</DataLocation>
<DefaultData>DomainsDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.DomainsD</IdLocation>
<IndexLocation>^ikra.Dictionary.DomainsI</IndexLocation>
<StreamLocation>^ikra.Dictionary.DomainsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

