Class ikra.Phones.Stat.ReviewStat Extends %Persistent
{

/// Review ID.
Property ReviewId As %Integer [ Required ];

Index ReviewIdIndex On ReviewId [ Unique ];

/// Phone ID.
Property PhoneId As %Integer [ Required ];

/// Phone Name.
Property PhoneName As %String;

Index PhoneNameIndex On PhoneName;

/// Positive markers sum in the review.
Property PositiveMarkersSum As %Integer [ InitialExpression = 0 ];

/// Negative markers sum in the review.
Property NegativeMarkersSum As %Integer [ InitialExpression = 0 ];

/// Total emotional markers sum in the review.
Property EmotionalSum As %Integer [ InitialExpression = 0 ];

/// Number of sentences in the review.
Property NumberOfSentences As %Integer [ InitialExpression = 0 ];

/// Number of entities in the review.
Property NumberOfEntities As %Integer [ InitialExpression = 0 ];

/// Emotional saturation of the review.
Property EmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {EmotionalSaturation} = {EmotionalSum} / {NumberOfEntities}}, SqlComputed ];

/// Positive emotional saturation of the review.
Property PositiveEmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {PositiveEmotionalSaturation} = {PositiveMarkersSum} / {NumberOfEntities}}, SqlComputed ];

/// Negative emotional saturation of the review.
Property NegativeEmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {NegativeEmotionalSaturation} = {NegativeMarkersSum} / {NumberOfEntities}}, SqlComputed ];

Property iKnowRating As %Numeric;

Storage Default
{
<Data name="ReviewStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReviewId</Value>
</Value>
<Value name="3">
<Value>HotelId</Value>
</Value>
<Value name="4">
<Value>HotelName</Value>
</Value>
<Value name="5">
<Value>PositiveMarkersSum</Value>
</Value>
<Value name="6">
<Value>NegativeMarkersSum</Value>
</Value>
<Value name="7">
<Value>EmotionalSum</Value>
</Value>
<Value name="8">
<Value>NumberOfSentences</Value>
</Value>
<Value name="9">
<Value>NumberOfEntities</Value>
</Value>
<Value name="10">
<Value>iKnowRating</Value>
</Value>
<Value name="11">
<Value>PhoneId</Value>
</Value>
<Value name="12">
<Value>PhoneName</Value>
</Value>
</Data>
<DataLocation>^ikra.Hotels4531.ReviewStatD</DataLocation>
<DefaultData>ReviewStatDefaultData</DefaultData>
<IdLocation>^ikra.Hotels4531.ReviewStatD</IdLocation>
<IndexLocation>^ikra.Hotels4531.ReviewStatI</IndexLocation>
<StreamLocation>^ikra.Hotels4531.ReviewStatS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

