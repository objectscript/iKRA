Class ikra.Dictionary.Load Extends %Persistent
{

ClassMethod LoadFunctional(sFolder As %String = "C:\InterSystems\Cache\CSP\ikra\Load\Fmarkers.txt")
{
	set cid = 0
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(sFolder)
	while 'stream.AtEnd {
		set str = stream.ReadLine()
		if (($piece(str, "#", 1) = "i") && ($piece(str, "#", 2) '= "END")) {
			set cName = $piece(str, "#", 2)
			&sql(INSERT INTO ikra_Dictionary.Category(CtgName) VALUES(:cName))
			&sql(SELECT ID INTO :cid FROM ikra_Dictionary.Category WHERE CtgName = :cName)
		}
		elseif ($piece(str, "#", 1) = "t") {
			set fName = $piece(str, "#", 2)
			&sql(INSERT INTO ikra_Dictionary.Fmarker(FName, CtgID) VALUES(:fName, :cid))
		}
	}
}

ClassMethod LoadEmotion(sFolder As %String = "C:\InterSystems\Cache\CSP\ikra\Load\Emarkers.txt")
{
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(sFolder)
	while 'stream.AtEnd {
		set str = stream.ReadLine()
		set eVal = $piece(str, "#", 1)
		set cName = $piece(str, "#", 2)
		set i = 1
		while ($piece(cName, ",", i) '= "") {
			set eName = $piece(cName, ",", i)
			set i = i + 1
			&sql(INSERT INTO ikra_Dictionary.EMarker(EName, EValue) VALUES(:eName, :eVal))
		}
	}
}

ClassMethod DellFunctional()
{
	do ##class(ikra.Dictionary.Category).%KillExtent()
	do ##class(ikra.Dictionary.Fmarker).%KillExtent()
	/*&sql(DELETE FROM ikra_Dictionary.Category)
	&sql(DELETE FROM ikra_Dictionary.FMarker)*/
}

ClassMethod DellEmotion()
{
	do ##class(ikra.Dictionary.EMarker).%KillExtent()
	/*&sql(DELETE FROM ikra_Dictionary.EMarker)*/
}

Storage Default
{
<Data name="LoadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ikra.Dictionary.LoadD</DataLocation>
<DefaultData>LoadDefaultData</DefaultData>
<IdLocation>^ikra.Dictionary.LoadD</IdLocation>
<IndexLocation>^ikra.Dictionary.LoadI</IndexLocation>
<StreamLocation>^ikra.Dictionary.LoadS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

