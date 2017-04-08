Class ikra.Phones.Stat.Review Extends %Persistent
{

/// Domain name
Property DomainName As %String [ Required ];

/// Source ID
Property SourceId As %Integer [ Required ];

Index PrimaryKey On (DomainName, SourceId) [ PrimaryKey, Unique ];

/// Author's rating of phone.
Property AuthorRating As %Numeric;

/// Estimated rating of phone.
Property iKnowRating As %Numeric;

/// Estimated rating of phone without excluding functional markers.
Property iKnowEmarkersRating As %Numeric;

/// Estimated rating of comfort.
Property iKnowRatingComfort As %Numeric;

/// Estimated rating of perfomance.
Property iKnowRatingPerfomance As %Numeric;

/// Estimated rating of link.
Property iKnowRatingLink As %Numeric;

/// Estimated rating of camera.
Property iKnowRatingCamera As %Numeric;

Property PhoneId As %Integer;

Property Suspect As %Integer [ InitialExpression = 0 ];

Property Usefulness As %Numeric [ InitialExpression = 0 ];

Storage Default
{
<Data name="ReviewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DomainName</Value>
</Value>
<Value name="3">
<Value>SourceId</Value>
</Value>
<Value name="4">
<Value>AuthorRating</Value>
</Value>
<Value name="5">
<Value>iKnowRating</Value>
</Value>
<Value name="6">
<Value>iKnowEmarkersRating</Value>
</Value>
<Value name="7">
<Value>iKnowRatingComfort</Value>
</Value>
<Value name="8">
<Value>iKnowRatingPerfomance</Value>
</Value>
<Value name="9">
<Value>iKnowRatingLink</Value>
</Value>
<Value name="10">
<Value>iKnowRatingCamera</Value>
</Value>
<Value name="11">
<Value>PhoneId</Value>
</Value>
<Value name="12">
<Value>Suspect</Value>
</Value>
<Value name="13">
<Value>Usefulness</Value>
</Value>
</Data>
<DataLocation>^ikra.Phones.Stat.ReviewD</DataLocation>
<DefaultData>ReviewDefaultData</DefaultData>
<IdLocation>^ikra.Phones.Stat.ReviewD</IdLocation>
<IndexLocation>^ikra.Phones.Stat.ReviewI</IndexLocation>
<StreamLocation>^ikra.Phones.Stat.ReviewS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

