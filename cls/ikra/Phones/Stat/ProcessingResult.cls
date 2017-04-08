Class ikra.Phones.Stat.ProcessingResult Extends %Persistent
{

/// Domain name
Property DomainName As %String;

/// Emarkers dictionary size.
Property EDictionarySize As %Integer;

/// Fmarkers dictionary size
Property FDictionarySize As %Integer;

/// Emotional index (Ratio of the average saturation of reviews to the size of the dictionary.)
Property EmotionalIndex As %Numeric;

/// Positive emotional index
Property PositiveIndex As %Numeric;

/// Negative emotional index
Property NegativeIndex As %Numeric;

/// Number of sources
Property NumberOfSources As %Integer;

/// The Negation flag
Property Negation As %String;

Property CorrelationPhone As %Numeric;

Property CorrelationComfort As %Numeric;

Property CorrelationPerfomance As %Numeric;

Property CorrelationLink As %Numeric;

Property CorrelationCamera As %Numeric;

/// Timestamp of processing endtime.
Property ProcessingDateTime As %TimeStamp;

Property CaclAlgorithm As %String;

Storage Default
{
<Data name="ProcessingResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DomainName</Value>
</Value>
<Value name="3">
<Value>EDictionarySize</Value>
</Value>
<Value name="4">
<Value>FDictionarySize</Value>
</Value>
<Value name="5">
<Value>EmotionalIndex</Value>
</Value>
<Value name="6">
<Value>PositiveIndex</Value>
</Value>
<Value name="7">
<Value>NegativeIndex</Value>
</Value>
<Value name="8">
<Value>NumberOfSources</Value>
</Value>
<Value name="9">
<Value>Negation</Value>
</Value>
<Value name="10">
<Value>CorrelationComfort</Value>
</Value>
<Value name="11">
<Value>CorrelationPerfomance</Value>
</Value>
<Value name="12">
<Value>CorrelationLink</Value>
</Value>
<Value name="13">
<Value>CorrelationCamera</Value>
</Value>
<Value name="14">
<Value>ProcessingDateTime</Value>
</Value>
<Value name="15">
<Value>CaclAlgorithm</Value>
</Value>
<Value name="16">
<Value>CorrelationPhone</Value>
</Value>
</Data>
<DataLocation>^ikra.PhE6BE.ProcessingRCBCAD</DataLocation>
<DefaultData>ProcessingResultDefaultData</DefaultData>
<IdLocation>^ikra.PhE6BE.ProcessingRCBCAD</IdLocation>
<IndexLocation>^ikra.PhE6BE.ProcessingRCBCAI</IndexLocation>
<StreamLocation>^ikra.PhE6BE.ProcessingRCBCAS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

