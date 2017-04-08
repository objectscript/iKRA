Include %IKPublic

Class ikra.Phones.Processing.Dictionary
{

ClassMethod TeachFMarkersDictionaryBD(domName As %String) As %Status
{
	
	kill ^fmarkers
	
	set domainId = ##class(ikra.util.main).GetDomainId(domName)
	set i = 1
	
	&sql(declare cur1 cursor for 
   		select case when tb.nm = 0 then 'i#' else 't#' end || tb.fname
   		into :line
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
		set stype = $piece(line,"#",1)
		if (stype = "i") { // "i" - Category
			set ^fmarkers(i) = line
			set i = i + 1
		}
		elseif (stype="t") { // "t" - term 
			set entityValue = $piece(line,"#",2)			
			set ^fmarkers(i) = "t#"_entityValue
			set i = i + 1
			kill similarResult				
			// Obtain similar entities IDs
			set status = ##class(%iKnow.Queries.EntityAPI).GetSimilar(.similarResult, domainId, entityValue, 1, 0, , ,$$$USEWORDS)
				
			if '($data(similarResult(1))) {
				&sql(fetch cur1)
				continue
			}
				
			set k1 = 1
			set p1 = ""
				
			// Loop through similar entities
			for {	
				set p1 = $order(similarResult(p1))	
				quit:(p1 = "")
				
				// Obtain ID of the similar entity
				set similarEntityId = $list(similarResult(k1),1)
					
				set similarEntity = ##class(%iKnow.Queries.EntityAPI).GetValue(domainId,similarEntityId)
					
				if (similarEntity '= entityValue) {
					set ^fmarkers(i) = "s#"_similarEntity
					set i = i + 1
				}
												
				set k1 = k1 + 1
			} // for (Similar)
				
		}	// elseif (stype="t") 
		
		set ^fmarkers(i) = "i#END"
		&sql(fetch cur1)
	}
	
	&sql(close cur1)
				
	return $$$OK
}

ClassMethod TeachEMarkersDictionaryBD(domName As %String) As %Status
{
	kill ^emarkers

	set domainId = ##class(ikra.util.main).GetDomainId(domName)
	set i = 1
	
	&sql(declare cur cursor for select case when EValue > 0 then '+' || EValue else '' || EValue end || '#' || EName into :line from ikra_dictionary.emarker order by EName)
   	&sql(open cur)
   	&sql(fetch cur)
	
	while (SQLCODE = 0) {
		set price = $piece(line,"#",1)
		set entityValue = $piece(line,"#",2)
		set ^emarkers(i) = price_"#"_entityValue
		
		set i = i + 1
		kill similarResult
							
		// Obtain similar entities IDs
		do ##class(%iKnow.Queries.EntityAPI).GetSimilar(.similarResult, domainId, entityValue, 1, 0, , ,$$$USEWORDS) // $$USENGRAMS $$$USEWORDS
			
		if '($data(similarResult(1))) { 
			&sql( fetch cur)
			continue 
		}
				
		set k1 = 1
		set p1 = ""
				
		// Loop through similar entities
		for {	
			set p1 = $order(similarResult(p1))	
			quit:(p1 = "")
			// Obtain ID of the similar entity
			set similarEntityId = $list(similarResult(k1),1)
			set similarEntity = ##class(%iKnow.Queries.EntityAPI).GetValue(domainId,similarEntityId)
			if (similarEntity '= entityValue) {
				set ^emarkers(i) = price_"#"_similarEntity
				set i = i + 1
			}					
			set k1 = k1 + 1
		} // for (Similar)
			
		&sql(fetch cur)	
	}
	
	&sql(close cur)
		
	return $$$OK
}

/// The method according to brief dictionary of functional markers forms complete dictionary, which includes similar concepts (s#)
/// domName - Domain name
/// writeToFile - filename to write a full list of similar terms. If writeToFile = "", it is not written. Example value: "fullFMarkersDict.txt"
ClassMethod TeachFMarkersDictionary(domName As %String, writeToFile As %String = "") As %Status
{
	
	kill ^fmarkers
	
	set domainId = ##class(ikra.util.main).GetDomainId(domName)	

	// Open the file with the dictionary of functional markers.		
	set fileNameIn = ^ikraDomainFolder(domName)_"Fmarkers.txt"
	set streamIn  = ##class(%Stream.FileCharacter).%New()
	set tSC = streamIn.LinkToFile(fileNameIn)
	
	if (tSC '= $$$OK) {
		return tSC
	}
	
	write "   fmarkers input file... ", fileNameIn, !
	
	// creating output file	
	if (writeToFile '= "") {
		set fileNameOut = ^ikraDomainFolder(domName)_writeToFile
		set streamOut = ##class(%Stream.FileCharacter).%New()
		set tSC = streamOut.LinkToFile(fileNameOut)	
		
		if (tSC '= $$$OK) {
			return tSC
		}
		
		write "   fmarkers output file... ", fileNameOut,!
	}	
	
	set i = 1
			
	// Loop through lines of file	
	while '(streamIn.AtEnd) {
				
		set line = streamIn.ReadLine()
		
		if (writeToFile '= "") {
			do streamOut.WriteLine(line)
		}
		
		// Check, does a string begin with a "!" (! - comment)			
		set checkComment = $piece(line,"!",1,1)
		if (checkComment="") {
			set ^fmarkers(i) = line
			set i = i + 1
			continue
		}
		
		set stype = $piece(line,"#",1)
		
		if (stype = "d") {		// "d" - Dictionary
			set ^fmarkers(i) = line
			set i = i + 1
			continue
		}
		elseif (stype = "i") {	// "i" - Category
			set ^fmarkers(i) = line
			set i = i + 1
			continue
		}
		elseif (stype="t") {	// "t" - term 
	
			set dList = $piece(line,"#",2)
			set j = 1
			
			// Loop through terms in one line
			while ($piece(dList,",",j) '= "") {	
			
				// $piece(dList,",",j) - current term
				set entityValue = $piece(dList,",",j)
				
				set ^fmarkers(i) = "t#"_entityValue
				
				set i = i + 1
				
				kill similarResult				
				// Obtain similar entities IDs
				set status = ##class(%iKnow.Queries.EntityAPI).GetSimilar(.similarResult, domainId, entityValue, 1, 0, , ,$$$USEWORDS)
				
				if '($data(similarResult(1))) { 
					set j = j + 1
					continue 
				}
				
				set k1 = 1
				set p1 = ""
				
				// Loop through similar entities
				for {	
					set p1 = $order(similarResult(p1))	
					quit:(p1 = "")
					
					// Obtain ID of the similar entity
					set similarEntityId = $list(similarResult(k1),1)
					
					set similarEntity = ##class(%iKnow.Queries.EntityAPI).GetValue(domainId,similarEntityId)
					
					if (similarEntity '= entityValue) {
						set ^fmarkers(i) = "s#"_similarEntity
						if (writeToFile '= "")	{do streamOut.WriteLine("s#"_similarEntity)}
						set i = i + 1
					}

					set k2 = 1
					set p2 = ""
					
					if '($data(result(1))) { 
						set k1 = k1 + 1
						continue 
					}
										
					
					set k1 = k1 + 1
				} // for (Similar)
				
				set j = j + 1
			} // While (Line)
				
		}	// elseif (stype="t") 		
		
	} // while ('stream.AtEnd)
		
	write "   Dictionary placed in ^fmarkers [global].", !		
	if (writeToFile '= "")	
	{
		do streamOut.%Save()
		write "   extended dictionary is written to file: "_filenameOut,! 
	}		
	return $$$OK
}

/// The method according to brief dictionary of emotional markers forms complete dictionary, which includes similar concepts
/// domName - Domain name
/// writeToFile - filename to write a full list of similar terms. If writeToFile = "", it is not written. Example value: "fullEMarkersDict.txt"
ClassMethod TeachEMarkersDictionary(domName As %String, writeToFile As %String = "") As %Status
{
	
	kill ^emarkers

	set domainId = ##class(ikra.util.main).GetDomainId(domName)	

	// Open the file with the dictionary of functional markers.		
	set fileNameIn = ^ikraDomainFolder(domName)_"Emarkers.txt"
	set streamIn  = ##class(%Stream.FileCharacter).%New()
	set tSC = streamIn.LinkToFile(fileNameIn)
	
	if (tSC '= $$$OK) {
		return tSC
	}
	
	write "   fmarkers input file... ", fileNameIn, !
	
	// creating output file	
	if (writeToFile '= "") {
		set fileNameOut = ^ikraDomainFolder(domName)_writeToFile
		set streamOut = ##class(%Stream.FileCharacter).%New()
		set tSC = streamOut.LinkToFile(fileNameOut)	
		
		if (tSC '= $$$OK) {
			return tSC
		}
		
		write "   fmarkers output file... ", fileNameOut,!
	}
	
	set i = 1
			
	// Loop through lines of file	
	while '(streamIn.AtEnd) {		
		set line = streamIn.ReadLine()
		
		if (writeToFile '= "") {
			do streamOut.WriteLine(line)
		}	
			
		// Check, does a string begin with a "!" (! - comment)	
		set checkComment = $piece(line,"!",1,1)
		if (checkComment="") {
			set ^emarkers(i) = line
			set i = i + 1
			continue
		}
		
		set price = $piece(line,"#",1)
		set dList = $piece(line,"#",2)
		set j = 1
			
		// Loop through terms in one line
		while ($piece(dList,",",j) '= "") {	
			
			// $piece(dList,",",j) - current term(entity)
			set entityValue = $piece(dList,",",j)
			//set j = j + 1

			set ^emarkers(i) = price_"#"_entityValue
			set i = i + 1
				
			kill similarResult
							
			// Obtain similar entities IDs
			do ##class(%iKnow.Queries.EntityAPI).GetSimilar(.similarResult, domainId, entityValue, 1, 0, , ,$$$USEWORDS) // $$USENGRAMS $$$USEWORDS
			
			if '($data(similarResult(1))) { 
				set j = j + 1
				continue 
			}
				
			set k1 = 1
			set p1 = ""
				
			// Loop through similar entities
			for {	
				set p1 = $order(similarResult(p1))	
				quit:(p1 = "")
				
				// Obtain ID of the similar entity
				set similarEntityId = $list(similarResult(k1),1)
				
				set similarEntity = ##class(%iKnow.Queries.EntityAPI).GetValue(domainId,similarEntityId)
				
				if (similarEntity '= entityValue) {
					set ^emarkers(i) = price_"#"_similarEntity
					if (writeToFile '= "")	{do streamOut.WriteLine(price_"#"_similarEntity)}
					set i = i + 1
				}

				set k2 = 1
				set p2 = ""
					
				if '($data(result(1))) { 
					set k1 = k1 + 1
					continue 
				}
										
					
				set k1 = k1 + 1
			} // for (Similar)
				
			set j = j + 1
		} // While (Line)
					
	} // while ('stream.AtEnd)

	write "   Dictionary placed in ^emarkers [global].", !
	if (writeToFile '= "") {	
		do streamOut.%Save()
		write "   extended dictionary is written to file: "_filenameOut,! 
	}
			
	return $$$OK
}

}

