Class ikra.REST.JSON Extends %Base
{

/***************************************************************************************/

/********************************* Работа с категориями ********************************/

/***************************************************************************************/
ClassMethod GetAllCategories() As %Status
{
   set st=$$$OK
   try {
	   do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select * from ikra_dictionary.category order by CtgName")
   } catch ex {
       set st=ex.AsStatus()
   }
   quit st
}

ClassMethod CreateCategory() As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
	
    s st=$$$OK
    try {
    	// Берём JSON из запроса и конвертируем в объект класса ikra.Dictionary.Category
    	$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,"ikra.Dictionary.Category",.obj,1))
    	$$$THROWONERROR(st,obj.%Save())
    } 
    catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod DeleteCategory(catid As %Integer) As %Status
{
    set st=$$$OK
    try {
        $$$THROWONERROR(st,##class(ikra.Dictionary.Category).%DeleteId(catid))
    } catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod UpdateCategory(catid As %Integer) As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
 	set st=$$$OK
 	try {
   
   		$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,,.obj,1))
   
   		// Открываем объект, который хотим отредакнировать
   		set ctg=##class(ikra.Dictionary.Category).%OpenId(catid)
   		throw:ctg=$$$NULLOREF ##class(%Exception.StatusException).CreateFromStatus($$$ERROR(5001,"Category does not exist"))
    	// Редактируем и сохраняем
   		set ctg.CtgName=obj.CtgName
   		$$$THROWONERROR(st,ctg.%Save())
 	} 
 	catch ex {
   		set st=ex.AsStatus()
 	}
 	quit st
}

/***************************************************************************************/

/********************************* Работа с концептами *********************************/

/***************************************************************************************/
ClassMethod GetAllConcepts(cncptid As %Integer) As %Status
{
   set st=$$$OK
   try {
	   do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select * from ikra_dictionary.fmarker where CtgId = "_cncptid_" order by FName")
   } catch ex {
       set st=ex.AsStatus()
   }
   quit st
}

ClassMethod CreateConcept() As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
	
    s st=$$$OK
    try {
    	// Берём JSON из запроса и конвертируем в объект класса ikra.Dictionary.Category
    	$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,"ikra.Dictionary.Fmarker",.obj,1))
    	$$$THROWONERROR(st,obj.%Save())
    } 
    catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod DeleteConcept(cncptid As %Integer) As %Status
{
    set st=$$$OK
    try {
        $$$THROWONERROR(st,##class(ikra.Dictionary.Fmarker).%DeleteId(cncptid))
    } catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod UpdateConcept(cncptid As %Integer) As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
 	set st=$$$OK
 	try {
   
   		$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,,.obj,1))
   
   		// Открываем объект, который хотим отредакнировать
   		set ctg=##class(ikra.Dictionary.Fmarker).%OpenId(cncptid)
   		throw:ctg=$$$NULLOREF ##class(%Exception.StatusException).CreateFromStatus($$$ERROR(5001,"Concept does not exist"))
    	// Редактируем и сохраняем
   		set ctg.FName=obj.FName
   		$$$THROWONERROR(st,ctg.%Save())
 	} 
 	catch ex {
   		set st=ex.AsStatus()
 	}
 	quit st
}

/***************************************************************************************/

/********************************** Работа с эмоциями **********************************/

/***************************************************************************************/
ClassMethod GetAllEmotions() As %Status
{
   set st=$$$OK
   try {
	   do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select * from ikra_dictionary.emarker order by EName")
   } catch ex {
       set st=ex.AsStatus()
   }
   quit st
}

ClassMethod CreateEmotion() As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
	
    s st=$$$OK
    try {
    	// Берём JSON из запроса и конвертируем в объект класса ikra.Dictionary.Category
    	$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,"ikra.Dictionary.EMarker",.obj,1))
    	$$$THROWONERROR(st,obj.%Save())
    } 
    catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod DeleteEmotion(emtid As %Integer) As %Status
{
    set st=$$$OK
    try {
        $$$THROWONERROR(st,##class(ikra.Dictionary.EMarker).%DeleteId(emtid))
    } catch ex {
        s st=ex.AsStatus()
    }
    quit st
}

ClassMethod UpdateEmotion(emtid As %Integer) As %Status
{
	set content = %request.Content.Read($$$MaxStringLength)
	set content = $ZCVT(content,"I","UTF8") 
 	set st=$$$OK
 	try {
   
   		$$$THROWONERROR(st,##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(content,,.obj,1))
   
   		// Открываем объект, который хотим отредакнировать
   		set ctg=##class(ikra.Dictionary.EMarker).%OpenId(emtid)
   		throw:ctg=$$$NULLOREF ##class(%Exception.StatusException).CreateFromStatus($$$ERROR(5001,"Emotion does not exist"))
    	// Редактируем и сохраняем
    	set ctg.EValue=obj.EValue
   		set ctg.EName=obj.EName
   		$$$THROWONERROR(st,ctg.%Save())
 	} 
 	catch ex {
   		set st=ex.AsStatus()
 	}
 	quit st
}

/***************************************************************************************/

/********************************** Работа с файлами ***********************************/

/***************************************************************************************/
ClassMethod UploadFileFunctional() As %Status
{
	If ($Data(%request.MimeData("file",1))) {
		do ##class(ikra.Dictionary.Fmarker).%KillExtent()
		do ##class(ikra.Dictionary.Category).%KillExtent()
		write "File contents, first line:"_$$$NL
		set stream = ##class(%Stream.FileCharacter).%New()
		set stream = %request.GetMimeData("file",1)
		while 'stream.AtEnd {
			set str = stream.ReadLine()
			set str = $ZCVT(str,"I","UTF8") 
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
    quit $$$OK
}

ClassMethod UploadFileEmotion() As %Status
{
	If ($Data(%request.MimeData("file",1))) {
		do ##class(ikra.Dictionary.EMarker).%KillExtent()
		write "File contents, first line:"_$$$NL
		set stream = ##class(%Stream.FileCharacter).%New()
		set stream = %request.GetMimeData("file",1)
		while 'stream.AtEnd {
			set str = stream.ReadLine()
			set str = $ZCVT(str,"I","UTF8") 
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
    quit $$$OK
}

ClassMethod DownloadFileEmotion() As %Status
{
   set st=$$$OK
   set sFolder = "C:\InterSystems\Cache\CSP\ikra\files\emotion.txt"
   set stream = ##class(%Stream.FileCharacter).%New()
   set sc = stream.LinkToFile(sFolder)
   
   &sql(declare cur cursor for select EName, case when EValue > 0 then '+' || EValue else '' || EValue end into :ename, :evalue from ikra_dictionary.emarker order by EName)
   &sql(open cur)
   &sql(fetch cur)
	
	while (SQLCODE = 0) {
		do stream.WriteLine(evalue_"#"_ename)
		&sql(fetch cur)
		if (SQLCODE = 0) {
			do stream.WriteLine(evalue_"#"_ename)
			&sql(fetch cur)
		}	
	}
	
	&sql(close cur)
	do stream.%Save()
	
   
   write "files/emotion.txt"
   quit st
}

ClassMethod DownloadFileFunctional() As %Status
{
   set st=$$$OK
   set sFolder = "C:\InterSystems\Cache\CSP\ikra\files\functional.txt"
   set stream = ##class(%Stream.FileCharacter).%New()
   set sc = stream.LinkToFile(sFolder)
   
   &sql(declare cur1 cursor for 
   	select case when tb.nm = 0 then 'i#' else 't#' end || tb.fname
   	into :str
	from
	(select ctg.ctgname, 1 nm, fmr.fname
	from ikra_dictionary.category ctg
	join ikra_dictionary.fmarker fmr on ctg.id = fmr.ctgid
	union all
	select ctgname, 0, ctgname
	from ikra_dictionary.category) tb
	order by ctgname, nm, fname)
   &sql(open cur1)
   &sql(fetch cur1)
	
	while (SQLCODE = 0) {
		do stream.WriteLine(str)
		&sql(fetch cur1)
	}
	do stream.Write("i#END")
	
	&sql(close cur1)
	do stream.%Save()
	
   
   write "files/functional.txt"
   quit st
}

/***************************************************************************************/

/********************************** Работа с доменами **********************************/

/***************************************************************************************/
ClassMethod GetAllDomainNames() As %Status
{
   set st = $$$OK
   //set ^tcnt = ^tcnt + 1
   //set ^tlog(^tcnt) = "+"
   
   set statement=##class(%SQL.Statement).%New()
   set status=statement.%PrepareClassQuery("%iKnow.Domain","GetAllDomains")
   if $$$ISERR(status) { do $system.OBJ.DisplayError(status) }
   set resultset=statement.%Execute()
   
   do ##class(ikra.Dictionary.Domains).%KillExtent()
   while resultset.%Next() {
	   set dName = resultset.%Get("domainName")
	   //set ^tlog(^tcnt) = ^tlog(^tcnt)_" "_dName
	   &sql(INSERT INTO ikra_Dictionary.Domains(dmnName) VALUES(:dName))
	}
   
   try {
	   do ##class(%ZEN.Auxiliary.jsonSQLProvider).%WriteJSONFromSQL(,"select * from ikra_dictionary.domains order by dmnName")
   } catch ex {
       set st=ex.AsStatus()
   }
   
   quit st
}

ClassMethod StartCompute(domName As %String) As %Status
{
   set st=$$$OK
   
   do ##class(ikra.Phones.Processing.Processing).Start(domName)
   do ##class(ikra.util.DeepSeeUtils).updateDSCubes("IKRACube01")
   
   quit st
}

}

