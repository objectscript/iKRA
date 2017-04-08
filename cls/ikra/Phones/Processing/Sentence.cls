Class ikra.Phones.Processing.Sentence Extends %Persistent
{

/// Sentence ID
Property SentenceId As %Integer [ Required ];

Index SentenceIdIndex On SentenceId [ Unique ];

/// Domain name
Property DomainName As %String [ Required ];

/// Number of positive markers.
Property Positive As %Integer [ InitialExpression = 0 ];

/// Number of negative markers.
Property Negative As %Integer [ InitialExpression = 0 ];

/// The Negation flag.
Property Negation As %Integer [ InitialExpression = 1 ];

Property nFmarkers As %Integer [ InitialExpression = 0 ];

Property nWords As %Integer [ InitialExpression = 0 ];

Property SrcId As %Integer;

Storage Default
{
<Data name="SentenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SentenceId</Value>
</Value>
<Value name="3">
<Value>DomainName</Value>
</Value>
<Value name="4">
<Value>Positive</Value>
</Value>
<Value name="5">
<Value>Negative</Value>
</Value>
<Value name="6">
<Value>Negation</Value>
</Value>
<Value name="7">
<Value>nFmarkers</Value>
</Value>
<Value name="8">
<Value>nWords</Value>
</Value>
<Value name="9">
<Value>SrcId</Value>
</Value>
</Data>
<DataLocation>^ikra.Phones.PrC684.SentenceD</DataLocation>
<DefaultData>SentenceDefaultData</DefaultData>
<IdLocation>^ikra.Phones.PrC684.SentenceD</IdLocation>
<IndexLocation>^ikra.Phones.PrC684.SentenceI</IndexLocation>
<StreamLocation>^ikra.Phones.PrC684.SentenceS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

