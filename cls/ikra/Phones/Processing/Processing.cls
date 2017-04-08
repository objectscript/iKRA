Include %IKPublic

Class ikra.Phones.Processing.Processing Extends %RegisteredObject
{

ClassMethod Start(domName As %String) As %Status
{
	
	kill ^preferences
	
	set fileNameIn = ^ikraDomainFolder(domName)_"Prefs.txt"
	set streamIn  = ##class(%Stream.FileCharacter).%New()
	set tSC = streamIn.LinkToFile(fileNameIn)
	
	if (streamIn.%IsNull()) {
		write "There is no Preferences file. Will use the default settings.", !
		
		do streamIn.WriteLine("NEUTRALLOWBORDER = 2.75")	
		do streamIn.WriteLine("NEUTRALHIGHBORDER = 3.25")	
		do streamIn.WriteLine("PESSUSPECT = 0.99")	
		do streamIn.WriteLine("NFMARKERS = 1")	
		do streamIn.WriteLine("MAXSENTENCELENGTHTORETURN = 15")	
		do streamIn.WriteLine("CALCALGORITHM = SENTENCE")	
		do streamIn.WriteLine("NEGATION = EXCLUDE")
		do streamIn.WriteLine("GRADEMULTIPLIER = 10")
		do streamIn.WriteLine("GRADESUSPECTDIFF = 1")
		
		do streamIn.%Save()
	}
	
	return:(tSC '= $$$OK) tSC
	
	while '(streamIn.AtEnd) {
				
		set line = streamIn.ReadLine()
		
		if ($extract(line, 1, 1) = "#") { continue }
		elseif (($extract(line, 1, 1) '= "") && ($extract(line, 1, 1) '= " ")) {
			set line = $translate(line, " ", "")
		
			set parameter = $piece(line, "=", 1)
			set value = $piece(line, "=", 2)
		
			set ^preferences(parameter) = value
		}
	}
	
	if '($data(^preferences("CALCALGORITHM"))) {
		write "There is no CALCALGORITHM parameter. Use default settings: sentence.", !
		set ^preferences("CALCALGORITHM") = "sentence"	
	}
	else {
		if (($ZCONVERT(^preferences("CALCALGORITHM"),"L") '= "sentence") && ($ZCONVERT(^preferences("CALCALGORITHM"),"L") '= "path")) {
			write "CALCALGORITHM has not valid value. Use default settings: sentence.", !
			set ^preferences("CALCALGORITHM") = "sentence"
		}     
	}
	
	if '($data(^preferences("NEUTRALLOWBORDER"))) {
		write "There is no NEUTRALLOWBORDER parameter. Use default settings: 2.75.", !
		set ^preferences("NEUTRALLOWBORDER") = 2.75	
	}
	else {
		if ($ISVALIDNUM(^preferences("NEUTRALLOWBORDER"))) {
			write "NEUTRALLOWBORDER is not valid number. Use default settings: 2.75.", !
			set ^preferences("NEUTRALLOWBORDER") = 2.75
		}
	}
	
	if '($data(^preferences("NFMARKERS"))) {
		write "There is no NFMARKERS parameter. Use default settings: 1.", !
		set ^preferences("NFMARKERS") = 1	
	}
	else {
		if ($ISVALIDNUM(^preferences("NFMARKERS"))) {
			write "NFMARKERS is not valid number. Use default settings: 1.", !
			set ^preferences("NFMARKERS") = 1
		}
	}
	
	if '($data(^preferences("PESSUSPECT"))) {
		write "There is no PESSUSPECT parameter. Use default settings: 0.99.", !
		set ^preferences("PESSUSPECT") = 0.99
	}
	else {
		if ($ISVALIDNUM(^preferences("PESSUSPECT"))) {
			write "PESSUSPECT is not valid number. Use default settings: 0.99.", !
			set ^preferences("PESSUSPECT") = 0.99
		}
	}
	
	if '($data(^preferences("NEUTRALHIGHBORDER"))) {
		write "There is no NEUTRALHIGHBORDER parameter. Use default settings: 3.25.", !
		set ^preferences("NEUTRALHIGHBORDER") = 3.25	
	}
	else {
		if '($ISVALIDNUM(^preferences("NEUTRALHIGHBORDER"))) {
			write "NEUTRALHIGHBORDER is not valid number. Use default settings: 3.25.", !
			set ^preferences("NEUTRALHIGHBORDER") = 3.25	
		}     
	}
	
	if '($data(^preferences("MAXSENTENCELENGTHTORETURN"))) {
		write "There is no MAXSENTENCELENGTHTORETURN parameter. Use default settings: 15.", !
		set ^preferences("MAXSENTENCELENGTHTORETURN") = 15
	}
	else {
		if '($ISVALIDNUM(^preferences("MAXSENTENCELENGTHTORETURN"))) {
			write "MAXSENTENCELENGTHTORETURN is not valid number. Use default settings: 15.", !
			set ^preferences("MAXSENTENCELENGTHTORETURN") = 15	
		}     
	}
	
	if '($data(^preferences("GRADEMULTIPLIER"))) {
		write "There is no GRADEMULTIPLIER parameter. Use default settings: 5.", !
		set ^preferences("GRADEMULTIPLIER") = 10	
	}
	else {
		if '($ISVALIDNUM(^preferences("GRADEMULTIPLIER"))) {
			write "GRADEMULTIPLIER is not valid number. Use default settings: 5.", !
			set ^preferences("GRADEMULTIPLIER") = 10
		}     
	}	
	
	if '($data(^preferences("GRADESUSPECTDIFF"))) {
		write "There is no GRADESUSPECTDIFF parameter. Use default settings: 1.", !
		set ^preferences("GRADESUSPECTDIFF") = 1	
	}
	else {
		if '($ISVALIDNUM(^preferences("GRADESUSPECTDIFF"))) {
			write "GRADESUSPECTDIFF is not valid number. Use default settings: 1.", !
			set ^preferences("GRADESUSPECTDIFF") = 1
		}     
	}		
	
	if '($data(^preferences("NEGATION"))) {
		write "There is no NEGATION parameter. Use default settings: exclude.", !
		set ^preferences("NEGATION") = "exclude"
	}	
	else {
		if (($ZCONVERT(^preferences("NEGATION"),"L") '= "exclude") && ($ZCONVERT(^preferences("NEGATION"),"L") '= "exclude")) {
			write "NEGATION has not valid value. Use default settings: exclude.", !
			set ^preferences("NEGATION") = "exclude"
		}     
	}

	
	if ($data(^preferences("CALCALGORITHM"))) {
		if ($ZCONVERT(^preferences("CALCALGORITHM"),"L") = "path") {
			if ($data(^preferences("NEGATION"))) {
				if ($ZCONVERT(^preferences("NEGATION"),"L") = "exclude") {
					set tSC = ##class(ikra.Phones.Processing.Processing).ProcessAllSourcesPaths(domName, "exclude")
				}
				else {
					set tSC = ##class(ikra.Phones.Processing.Processing).ProcessAllSourcesPaths(domName, "ignore")
				}
			}
				else {
					write "Settings data corruption.", !
					return ERROR("Settings data corruption. NEGATION Parameter is missing. Reload the domain or fix the settings data.")	
				}
		}
		else {
			if ($data(^preferences("NEGATION"))) {
				if ($ZCONVERT(^preferences("NEGATION"),"L") = "ignore") {
					set tSC = ##class(ikra.Phones.Processing.Processing).ProcessAllSources(domName, "ignore")
				}
				else {
					set tSC = ##class(ikra.Phones.Processing.Processing).ProcessAllSources(domName, "inverse") //exclude
				}
			}
				else {
					write "Settings data corruption.", !
					return ERROR("Settings data corruption. NEGATION Parameter is missing. Reload the domain or fix the settings data.")	
				}
		}
	}
	else {
		write "Settings data corruption.", !
		return ERROR("Settings data corruption. CALCALGORITHM Parameter is missing. Reload the domain or fix the settings data.")	
	}
	
	return tSC
}

/// Method of processing all domain sources. Processing dictionaries, emarkers, fmarkers, total evaluation of phones, user sentences and etc.
/// domName - Domain name, negation: exclude - Exclude sentences with negation from processing, ignore - ignore negation.
ClassMethod ProcessAllSources(domName As %String, negation As %String = "ignore") As %Status
{
	
	set beginTime = $piece($horolog,",",2)
	write !, "Started at: ", $ztime(beginTime), !
	
	set domainId = ##class(ikra.util.main).GetDomainId(domName)	
	
	// Processing the dictionaries
	set tSC = ##class(ikra.Phones.Processing.Dictionary).TeachEMarkersDictionaryBD(domName)
	
	if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
		return $$$ERROR("Can't process emarkers dictionary")
	}
	
	set tSC = ##class(ikra.Phones.Processing.Dictionary).TeachFMarkersDictionaryBD(domName)
	
	if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
		return $$$ERROR("Can't process fmarkers dictionary")
	}
	
	/*write "   Clearing old stats.."
	set tSC = ..ClearStats()*/
	
	/*if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
	}
	else {
		write "  Done.", !
	}*/
	
	write "   Clearing old sentences.."
	set tSC = ..ClearSentences()
	
	if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
	}
	else {
		write "  Done.", !
	}
	
	write "   Processing Emotional markers.." 
	
	// Fill the Sentence table with counts of emotional markers
	set tSC = ..BuildProcessingSentences(domName)
	
	if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
	}
	else {
		write "  Done.", !
	}

	// Processing Negation
	write "   Processing Negation.."
	do ..ProcessNegationSentences(domName)
	write "  Done.", !
	
	/*
	set nFMarkers = ^preferences("NFMARKERS")
	do ..PreProcessFunctionalMarkers(domName, nFMarkers)
	*/
	
	kill ^review
	
	write "   Processing Functional markers.."
	set tSC = ..ProcessFunctionalMarkers(domName, negation)
	
	write:(tSC = $$$OK) "  Done.", !
	
	write "   Processing phones grades.."
	set tSC = ..ProcessPhonesGrades()
	
	if (tSC '= $$$OK) {
		do $System.Status.GetErrorText(tSC)
		w !
	}	
	else {
		write "  Done.", !
	}
	
	set maxLength = ^preferences("MAXSENTENCELENGTHTORETURN")
	
	set endTime = $piece($horolog,",",2)

	write !, "Elapsed time: ", $ztime(endTime - beginTime), !
	
	return $$$OK
}

/// The method analyzes the sentences of the sources on the emotional markers and fill the ikra_Phones_Processing.Sentence table.
ClassMethod BuildProcessingSentences(domName As %String) As %Status [ Private ]
{
	set domainId = ##class(ikra.util.main).GetDomainId(domName)	
	
	set p1 = ""	
		
	for {	
		
		set p1 = $order(^emarkers(p1))
		quit:(p1 = "")	
	
		set line = ^emarkers(p1)
		
		// Check, does a string begin with a "!" (! - comment)		
		set checkComment = $PIECE(line,"!", 1, 1)
		if (checkComment = "") { continue }
		
		// Obtain a term(entity) value.
		set sValue = $piece(line,"#", 1)	
		set entityValue = $piece(line,"#", 2)
		
		// Obtain the ID of current entity
		set entityId = ##class(%iKnow.Queries.EntityAPI).GetId(domainId, entityValue)	
	
		kill result	
		// Obtain a list of sentences in the sources containing this entity
		do ##class(%iKnow.Queries.SentenceAPI).GetByEntityIds(.result, domainId, $lb(entityId),, 1, 0)	
		
		if '($data(result(1))) { continue }			
		
		set p2 = ""
		
		// Loop on the sentences contained this entity
		for {		
					
			set p2 = $order(result(p2))	
			quit:(p2 = "")
			
			// Obtain the Sentence ID		
			set sentenceId = $list(result(p2), 3)	
			
			set sourceId = ##class(%iKnow.Queries.SentenceAPI).GetSourceId(domainId, sentenceId)
			
			// Obtain Sentence ID in the table
			&sql(SELECT ID INTO :id FROM  ikra_Phones_Processing.Sentence WHERE SentenceId = :sentenceId AND DomainName = :domName)
			
			// If the query does not return anything, then add a new record
			if (SQLCODE = 100) {	
				&sql(INSERT INTO ikra_Phones_Processing.Sentence (DomainName, SentenceId, SrcId) 
					 VALUES (:domName, :sentenceId, :sourceId))
				set id = ^ikra.Phones.PrC684.SentenceD
			}
			elseif (SQLCODE < 0) {
				write "Error during SQL query.", !
				write "   query returned SQLCODE: ", SQLCODE, !
				return $$$ERROR("SQL query error")	
			}
			
			// Adding value in the appropriate field. (Positive or Negative) 					
			if (sValue = "+1")		{set $list(^ikra.Phones.PrC684.SentenceD(id),4) = $list(^ikra.Phones.PrC684.SentenceD(id),4) + 1 }
			elseif (sValue = "-1")	{set $list(^ikra.Phones.PrC684.SentenceD(id),5) = $list(^ikra.Phones.PrC684.SentenceD(id),5) + 1 }
							
		}	// for (Sentence)
		
	} // while 'stream.AtEnd
	
	return $$$OK
}

/// Method of processing negative sentences.
ClassMethod ProcessNegationSentences(domName As %String) As %Status [ Private ]
{

	set ^shortNegSent = 0
	
	set domainId = ##class(ikra.util.main).GetDomainId(domName)	
	
	set length = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainId)
	
	for i=1:1:length {
		
		set srcId = i
		
		// Get the list of attribute values of sentences.
		do ##class(%iKnow.Queries.SourceAPI).GetAttributes(.att, domainId, srcId, 1, 0, "", $$$IKATTLVLSENT)
	    
	    set j = 1
	    
	    // Loop through the list of attribute values ​​to determine the Negation.
	    while $data(att(j)) {
	    	if ($listget(att(j), 1) = 1) {
	        			
				set sentenceId = $listget(att(j),4)
				
				// Obtain Sentence ID in the table
				&sql(SELECT ID INTO :id FROM  ikra_Phones_Processing.Sentence WHERE SentenceId = :sentenceId AND DomainName = :domName)
				
				// Switch the Positive and Negative values.
	           	if (SQLCODE = 0) {
	            	set temp = $list(^ikra.Phones.PrC684.SentenceD(id), 4)
	            	set $list(^ikra.Phones.PrC684.SentenceD(id),4) = $list(^ikra.Phones.PrC684.SentenceD(id),5)
	            	set $list(^ikra.Phones.PrC684.SentenceD(id),5) = temp
	            	set $list(^ikra.Phones.PrC684.SentenceD(id),6) = -1
	           	}
	        }
	        
	    	set j = j + 1
	    	
	    } // while
	}    
	return $$$OK
}

/// The method analyzes the sentences of the sources on the functional markers and fills fields iKnowRating* in the ikra_Phones_Stat.Review table.
ClassMethod ProcessFunctionalMarkers(domName As %String, negation As %String = "ignore") As %Status [ Private ]
{

	set domainId = ##class(ikra.util.main).GetDomainId(domName)	
	
	set length = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainId)
	
	if ($data(^preferences("GRADEMULTIPLIER"))) {
		if ($ISVALIDNUM(^preferences("GRADEMULTIPLIER"))) {
			set gradeMultiplier = ^preferences("GRADEMULTIPLIER")
		}
		else {
			write "GRADEMULTIPLIER is not valid number. Use default settings", !
			set gradeMultiplier = ^preferences("GRADEMULTIPLIER")
		}
	}	 
	else {
		write "Settings data corruption.", !
		return ERROR("Settings data corruption. NEGATION Parameter is missing. Reload the domain or fix the settings data.")	
	}		
			
	// The functional marker's category.
	set markerCategory = ""
	
	for i=1:1:length {
		
		set srcId = i
		
		// Positive and negative values ​​within the category.
		set ^review(srcId,"positive")  = 0
		set ^review(srcId,"negative")  = 0
		
		set ^review(srcId,"positiveMarkersSum") = 0
		set ^review(srcId,"negativeMarkersSum") = 0
		
		// Appraisal within the category.
		set ^review(srcId,"grade") = 0
		
		// Counter of evaluated categories.
		set ^review(srcId,"gradedCategoryCount") = 0
		
		// General grade.
		set ^review(srcId,"totalGrade") = 0
		
		// Positive and negative values ​​in the entire review.
		set ^review(srcId,"totalNegative") = 0
		set ^review(srcId,"totalPositive") = 0
	}
	
	set p1 = ""
		
	for	{	
	
		set p1 = $order(^fmarkers(p1))
		quit:(p1 = "")
		
		set line = ^fmarkers(p1)
				
		// Check, does a string begin with a "!" (! - comment)			
		set checkComment = $piece(line,"!",1,1)
		if (checkComment="") { continue }

		set stype = $piece(line,"#",1)
		
		if (stype = "d") { continue }
		// Processing the string with the name of the category
		elseif (stype = "i") {
			
			for i=1:1:length {
				set srcId = i
				kill ^review(srcId, "grade")
			}
			
			// If we have a category (the first pass it does not exist), estimate the grade for this category.
			if (markerCategory '= "") {		
				
				for i=1:1:length {
					
					set srcId = i
					
					if ((^review(srcId,"negative") = 0) && (^review(srcId,"positive") = 0)) { 
						kill ^review(srcId, "grade")	
					}
					elseif (^review(srcId,"negative") = 0) {
						set ^review(srcId,"grade") = 1 
					}
					elseif (^review(srcId,"positive") = 0) {
						set ^review(srcId,"grade") = 0.2 
					}
					else {	
						set ^review(srcId,"grade") = ^review(srcId,"positive") / (^review(srcId,"positive") + ^review(srcId,"negative"))
					}
							
					if $data(^review(srcId,"grade")) {	
					
						// Converting grade in the form of 1 to 5
						set ^review(srcId,"grade") = ^review(srcId,"grade") * gradeMultiplier
						
						set ^review(srcId,markerCategory) = ^review(srcId,"grade")
						set ^review(srcId,"gradedCategoryCount") = ^review(srcId,"gradedCategoryCount") + 1
						set ^review(srcId,"totalGrade") = ^review(srcId,"totalGrade") + ^review(srcId,"grade")
						
						set ^review(srcId,"positiveMarkersSum") = ^review(srcId,"positiveMarkersSum") + ^review(srcId,"positive")
						set ^review(srcId,"negativeMarkersSum") = ^review(srcId,"negativeMarkersSum") + ^review(srcId,"negative")
						
					}
					else {
						set ^review(srcId, markerCategory) = "" 
					}
					
					// Reset positive and negative (for the next category)
					set ^review(srcId,"positive") = 0
					set ^review(srcId,"negative") = 0
				}
			}
			
			// Obtain the name of the next category
			set markerCategory = $piece(line,"#",2)
		}
		
		// Processing the string with the term(entity)
		elseif ((stype="t") || (stype="s")) {
			
			// $piece(line,"#",2) - current term(entity)
			set entityValue = $piece(line,"#",2)
			set entityId = ##class(%iKnow.Queries.EntityAPI).GetId(domainId, entityValue)	

			kill result
			
			// Obtain a list of sentences in the sources containing this entity					
			set st = ##class(%iKnow.Queries.SentenceAPI).GetByEntityIds(.result, domainId, $lb(entityId),, 1, 0)			
			
			set p2 = ""
			
			if '($data(result(1))) { continue }
			
			// Loop through the sentences contained this entity
			for {		
						
				set p2 = $order(result(p2))	
				quit:(p2 = "")
				
				// Obtain the Sentence ID	
				set sentenceId = $list(result(p2), 3)	
				
				// Obtain the sentence values from table
				&sql(SELECT Negation, Negative, Positive, SrcId 
					 INTO :Negation, :sNegative, :sPositive, :srcId 
					 FROM  ikra_Phones_Processing.Sentence 
					 WHERE SentenceId = :sentenceId AND DomainName = :domName)
				
				// If the query does not return anything go to next sentence
				if (SQLCODE = 100) { continue }
				
				// Skipping sentences with the negation, if specified the negation parameter
				if ((negation = "exclude") && (Negation = -1)) { continue } 
				elseif ((negation = "ignore") && (Negation = -1)) {
					&sql(UPDATE ikra_Phones_Processing.Sentence (Negation, Negative, Positive)
					 	 VALUES(1, :sPositive, :sNegative)
					 	 WHERE SentenceId = :sentenceId)
					set temp = sPositive 
					set sPositive = sNegative
					set sNegative = temp
				}
						
				// Accumulate the values in the appropriate category
				set ^review(srcId,"positive") = ^review(srcId,"positive") + sPositive
				set ^review(srcId,"negative") = ^review(srcId,"negative") + sNegative
				set ^review(srcId,"totalNegative") = ^review(srcId,"totalNegative") + sNegative
				set ^review(srcId,"totalPositive") = ^review(srcId,"totalPositive") + sPositive
								
			}	// for (Sentence)

		}	// elseif (stype="t") 		
		
	} // while ('stream.AtEnd)
	
	for i=1:1:length {
	
		set srcId = i
		
		// If we have at least one estimated category, estimate the general grade
		if (^review(srcId,"gradedCategoryCount") > 0) {
			set ^review(srcId,"iKnowRating") = ^review(srcId,"totalGrade") / ^review(srcId,"gradedCategoryCount")
			
			// Present Emarkers grade in the form of 1 to 5.
			set ^review(srcId,"iKnowEmarkersRating") = $SYSTEM.SQL.CEILING($normalize((^review(srcId,"totalPositive") / (^review(srcId,"totalPositive") + ^review(srcId,"totalNegative"))) * gradeMultiplier - 0.1, -1) + 1)
		}
				
		//&sql(SELECT phoneId INTO :phoneId FROM ikra_Phones_Stat.Review WHERE SourceId = :srcId)
		&sql(SELECT MIN(UID) INTO :phoneId FROM ikra_Dictionary.MarksReview WHERE RID = :srcId)
		
		set phoneName = ##class(%iKnow.Queries.MetadataAPI).GetValue(domainId, "UnitName", ##class(%iKnow.Queries.SourceAPI).GetExternalId(domainId, srcId), .stn)
		
		set numberOfEntities = ##class(%iKnow.Queries.EntityAPI).GetCountBySource(domainId, srcId)
		if (numberOfEntities = 0) { set numberOfEntities = 1 }
		
		set positiveMarkersSum = ^review(srcId,"positiveMarkersSum")
		set negativeMarkersSum = ^review(srcId,"negativeMarkersSum")
		
		set emotionalSum = positiveMarkersSum + negativeMarkersSum
		set numberOfSentences = ##class(%iKnow.Queries.SentenceAPI).GetCountBySource(domainId, srcId)
		             
		&sql(declare curCtg cursor for select id, ctgName into :ccID, :ccName from ikra_dictionary.category)
   		&sql(open curCtg)
   		&sql(fetch curCtg)
   		
   		&sql(SELECT DISTINCT UID INTO :oID FROM ikra_Dictionary.MarksReview WHERE RID = :srcId)
	
		while (SQLCODE = 0) {
			set domID = ##class(ikra.util.main).GetDomainId(domName)
			write srcId_" "_ccName, !
			set catVal = ^review(srcId, ccName)
			&sql(INSERT OR UPDATE INTO ikra_Dictionary.MarksReview(DomainID, UID, RID, CtgID, Mark)	
			VALUES (:domID, :oID, :srcId, :ccID, :catVal))
			&sql(fetch curCtg)
		}
	
		&sql(close curCtg)
}

	
	return $$$OK
}

/// The method of calculating the final evaluation of phone.
ClassMethod ProcessPhonesGrades() As %Status [ Private ]
{
	kill unitIdList
	
	// Obtain a list of all objects	 
	&sql(DECLARE UntList Cursor FOR
		 SELECT DISTINCT UID INTO :tempUnitId FROM ikra_Dictionary.MarksReview ORDER BY UID)
	
	&sql(open UntList)
	&sql(fetch UntList)
	
	while (SQLCODE = 0) {
		set $list(unitIdList,*+1) = tempUnitId
		&sql(fetch UntList)	
	}
	
	&sql(close UntList)
	
	set untLength = $listlength(unitIdList)

	// Loop through all phones
	for i=1:1:untLength
	{			
		set unitId = $list(unitIdList, i)
		
		// Obtain the final evaluation of phone
		&sql(SELECT DISTINCT DomainID
        	 INTO :domID
		     FROM ikra_Dictionary.MarksReview)
		
		&sql(SELECT MIN(RID) INTO :srcId FROM ikra_Dictionary.MarksReview WHERE UID = :unitId)     
		set unitName = ##class(%iKnow.Queries.MetadataAPI).GetValue(domID, "UnitName", ##class(%iKnow.Queries.SourceAPI).GetExternalId(domID, srcId), .stn)
		
		&sql(declare curCtg1 cursor for select id, ctgName into :ccID, :ccName from ikra_dictionary.category)
   		&sql(open curCtg1)
   		&sql(fetch curCtg1)
	
		while (SQLCODE = 0) {
			&sql(SELECT AVG(NULLIF(Mark, 0))
        	 INTO :avgUnt
		     FROM ikra_Dictionary.MarksReview
		     WHERE UID = :unitId & CtgID = :ccID)
		     
		    &sql(INSERT OR UPDATE INTO ikra_Dictionary.MarksUnit 
			 (DomainID, UID, UName, CtgID, Mark)
			 VALUES (:domID, :unitId, :unitName, :ccID, :avgUnt))
			&sql(fetch curCtg1)
		}
	
		&sql(close curCtg1)
	}
	
	return $$$OK
}

/// Method of clearing the Sentence table.
ClassMethod ClearSentences() As %Status [ Private ]
{
		
	set tSC = ##class(ikra.Phones.Processing.Sentence).%KillExtent()
	
	return tSC
}

}

