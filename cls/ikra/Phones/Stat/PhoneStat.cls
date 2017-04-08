Class ikra.Phones.Stat.PhoneStat Extends %Persistent
{

/// Phone ID
Property PhoneId As %Integer [ Required ];

Index phoneIdIndex On PhoneId [ Unique ];

/// Hotel Name
Property PhoneName As %String [ Required ];

/// Positive markers sum in the review.
Property PositiveMarkersSum As %Numeric [ InitialExpression = 0 ];

/// Negative markers sum in the review.
Property NegativeMarkersSum As %Numeric [ InitialExpression = 0 ];

/// Total emotional markers sum in the review.
Property EmotionalSum As %Numeric [ InitialExpression = 0 ];

/// Number of sentences in the review.
Property NumberOfSentences As %Numeric [ InitialExpression = 0 ];

/// Number of entities in the review.
Property NumberOfEntities As %Numeric [ InitialExpression = 0 ];

/// Emotional saturation of the review.
Property EmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {EmotionalSaturation} = {EmotionalSum} / {NumberOfEntities}}, SqlComputed ];

/// Positive emotional saturation of the review.
Property PositiveEmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {PositiveEmotionalSaturation} = {PositiveMarkersSum} / {NumberOfEntities}}, SqlComputed ];

/// Negative emotional saturation of the review.
Property NegativeEmotionalSaturation As %Numeric [ Calculated, InitialExpression = 0, SqlComputeCode = {set {NegativeEmotionalSaturation} = {NegativeMarkersSum} / {NumberOfEntities}}, SqlComputed ];

Storage Default
{
<Data name="PhoneStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhoneId</Value>
</Value>
<Value name="3">
<Value>PhoneName</Value>
</Value>
<Value name="4">
<Value>PositiveMarkersSum</Value>
</Value>
<Value name="5">
<Value>NegativeMarkersSum</Value>
</Value>
<Value name="6">
<Value>EmotionalSum</Value>
</Value>
<Value name="7">
<Value>NumberOfSentences</Value>
</Value>
<Value name="8">
<Value>NumberOfEntities</Value>
</Value>
</Data>
<DataLocation>^ikra.Phones.Stat.PhoneStatD</DataLocation>
<DefaultData>PhoneStatDefaultData</DefaultData>
<IdLocation>^ikra.Phones.Stat.PhoneStatD</IdLocation>
<IndexLocation>^ikra.Phones.Stat.PhoneStatI</IndexLocation>
<StreamLocation>^ikra.Phones.Stat.PhoneStatS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

