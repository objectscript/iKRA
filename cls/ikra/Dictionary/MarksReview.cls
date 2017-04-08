Class ikra.Dictionary.MarksReview Extends %Persistent
{

Property DomainID As %Integer;

Property UID As %Integer;

Property RID As %Integer;

Property CtgID As %Integer;

Property Mark As %Numeric;

Index fkMR On (DomainID, UID, RID, CtgID) [ PrimaryKey, Unique ];

Storage Default
{
<Data name="MarksReviewDefaultData">
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
<Value>RID</Value>
</Value>
<Value name="5">
<Value>CtgID</Value>
</Value>
<Value name="6">
<Value>Mark</Value>
</Value>
</Data>
<DataLocation>^ikra.DictioD092.MarksReviewD</DataLocation>
<DefaultData>MarksReviewDefaultData</DefaultData>
<IdLocation>^ikra.DictioD092.MarksReviewD</IdLocation>
<IndexLocation>^ikra.DictioD092.MarksReviewI</IndexLocation>
<StreamLocation>^ikra.DictioD092.MarksReviewS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

