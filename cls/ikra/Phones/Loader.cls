Include %IKPublic

Class ikra.Phones.Loader
{

/// Method of loading reviews domain.
/// domName - Domain name.
/// domFolder - folder for creating a configuration.. Contains dictionaries, blacklists, etc.
/// For example, with call: do ##class(ikra.Phones.loader).Load("Phone", "D:\intuersystems\wPhones")
ClassMethod Load(domName As %String = "Phones", domFolder As %String = "C:\InterSystems\Cache\CSP\ikra\Load\") As %Status
{
	write "Loading started at: ", $zdatetime($horolog), !
	
	// If the domain does not exist, create a new (also creating a configuration)
	do ##class(ikra.util.main).CreateDomainIfNotExists(domName, domFolder)
	set domId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	// Set the name of configuration	
	#dim confName As %String = "Conf"_domName
	
	#dim lister As %iKnow.Source.File.Lister = ##class(%iKnow.Source.File.Lister).%New(domId)	
	do lister.SetConfig(confName)
	#dim initialNumOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)
	write "   lister created!",!
	
	//do lister.SetConfig(confName)
	set loader = ##class(%iKnow.Source.Loader).%New(domId)
	
	// Crating the Metadata fields	
	do ..SetMetaDataFields(domName)	
	
	// Forming batch
	// =================
	
	set pth = domFolder_"Sources.txt"
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc=stream.LinkToFile(pth)
	write "Link to file status: ",sc,!
	write "Loading data from sources ...",!
	set i = 0
	while 'stream.AtEnd {
		set line = stream.ReadLine()
		if ($piece(line, "#", 1) = "phone"){
			set pId = $piece(line, "#", 2)
			set pName = $piece(line, "#", 3)
		} elseif ($piece(line, "#", 1) = "data") {
			set i = i + 1
			set AutRat = $extract(line, $locate(line,"\(")+1, $locate(line,"\)")-1)
			set tSC=lister.AddListToBatch($piece(line, "#", 2),$LB("txt"),0,"")
			if (tSC '= $$$OK) { 
    			write "The lister failed: ",$System.Status.DisplayError(tSC)
    			return tSC 
    		}
    		// Insert/update record in ikra_Phones_Stat.Review
			&sql(INSERT OR UPDATE INTO ikra_Phones_Stat.Review 
		 		(DomainName, SourceId, AuthorRating, PhoneId)
		  		VALUES (:domName, :i, NULLIF({fn CONVERT(:AutRat,SQL_INTEGER)} ,0), {fn CONVERT(:pId,SQL_INTEGER)}))
			if (SQLCODE '= 0) {
				zw SQLCODE
				write "Error saving review #", i, !
			}
			
			set domID = ##class(ikra.util.main).GetDomainId(domName)
			&sql(INSERT OR UPDATE INTO ikra_Dictionary.MarksReview
		 		(DomainID, UID, RID, CtgID, Mark)
		  		VALUES (:domID, {fn CONVERT(:pId,SQL_INTEGER)}, :i, 1, 0))
			if (SQLCODE '= 0) {
				zw SQLCODE
				write "Error saving MarksReview #", i, !
			}
		}
	}
	
    // =================
      
    write "Adding List to Batch Complete!", !
    	
    set tSC = loader.ProcessBatch()      
    
    // In the event of an error, the process should not be interrupted, since errors can be harmless.
    if (tSC '= $$$OK) { 
    	write "The loader failed: ", $System.Status.DisplayError(tSC) 
    }
    
	#dim numOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)
	
	set pth = domFolder_"Metadata.txt"
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc=stream.LinkToFile(pth)
	write "Link to file status: ",sc,!
	write "Loading data from sources ...",!
	while 'stream.AtEnd {
		set line = stream.ReadLine()
		set $list(MetDat, *+1) = $LB($piece(line, "#", 1), $piece(line, "#", 2), $piece(line, "#", 3), $piece(line, "#", 4))
	}
	
	// Loop through all sources to fill ikra_Phones_Stat.Review table
	for i = initialNumOfSources+1:1:numOfSources 
	{
		set externalId = ##class(%iKnow.Queries.SourceAPI).GetExternalId(domId, i)
		
		for j = 1:1:$LL(MetDat){
			if ((i >= $list($list(MetDat, j), 1)) && (i <= $list($list(MetDat, j), 2))){
				&sql(
					SELECT AuthorRating INTO :AutRat
					FROM  ikra_Phones_Stat.Review  
					WHERE SourceId = :i)
				do ##class(%iKnow.Queries.MetadataAPI).SetValue(domId, "UnitId", externalId, $list($list(MetDat, j), 3))
				do ##class(%iKnow.Queries.MetadataAPI).SetValue(domId, "UnitName", externalId, $list($list(MetDat, j), 4))
				do ##class(%iKnow.Queries.MetadataAPI).SetValue(domId, "AuthorRating", externalId, AutRat)
				write "   In loader phone name is: "_$list($list(MetDat, j), 4)_" ar("_AutRat_") pId = "_$list($list(MetDat, j), 3), !
			}
		}	
	}
	
	write !, "Loading finished at: ", $zdatetime($horolog), !
				
	write !, "Initial Number of Sources: ", initialNumOfSources, !
	write "Sources Added: ", numOfSources - initialNumOfSources, !
	write "Total: ", numOfSources,!
	
	do ##class(ikra.Dictionary.Load).LoadFunctional()
	write !, "Functional markers loaded"
	do ##class(ikra.Dictionary.Load).LoadEmotion()
	write !, "Emotion markers loaded"
		
	return numOfSources - initialNumOfSources
}

/// Method of setting the metadata fields for reviews
/// domName - Domain name
ClassMethod SetMetaDataFields(domName As %String) As %Status
{
	set domainId = ##class(ikra.util.main).GetDomainId(domName)
	
	// Setting the metadata fields
	do ##class(%iKnow.Queries.MetadataAPI).AddField(domainId,"UnitId",,$$$MDDTSTRING)
	do ##class(%iKnow.Queries.MetadataAPI).AddField(domainId,"UnitName",,$$$MDDTSTRING)
	do ##class(%iKnow.Queries.MetadataAPI).AddField(domainId,"AuthorRating",,$$$MDDTSTRING)
	
	write "Metadata fields added.", !
	
	return $$$OK
}

/// Method of deleting metadata fields from specified domain
/// domName - Domain name
ClassMethod RemoveMetaDataFields(domName As %String) As %Status
{
	set domainId = ##class(ikra.util.main).GetDomainId(domName)
	
	set tSC = ##class(%iKnow.Queries.MetadataAPI).RemoveField(domainId, "PhoneId")
	set tSC = tSC + ##class(%iKnow.Queries.MetadataAPI).RemoveField(domainId, "PhoneName")
	
	if (tSC = 2) { write "all metadata fields are deleted", ! }
	else { write "errors in deleting metadata fields", ! }
		
	return tSC
}

/// Method of deleting a domain with all environment
ClassMethod Free(domName As %String = "Phones") As %Status
{
	kill ^ikraDomainFolder(domName)
	kill ^preferences
	#dim confName As %String = "Conf"_domName
	
	do ..RemoveMetaDataFields(domName)	
	do ##class(ikra.util.main).DeleteDictionaries(domName)			
	do ##class(ikra.util.main).DeleteBlackLists(domName, "GeneralBlackList")	
	
	set tSC = ##class(ikra.util.main).DeleteConfiguration(confName)
	
	if (tSC '= $$$OK) { write "Cannot delete configuration :", confName, $System.Status.DisplayError(tSC), ! }
	
	// Kill Extent of all classes
	do ##class(ikra.Dictionary.MarksUnit).%KillExtent()
	do ##class(ikra.Dictionary.MarksReview).%KillExtent()
	
	do ##class(ikra.Dictionary.Category).%KillExtent()
	do ##class(ikra.Dictionary.Fmarker).%KillExtent()
	do ##class(ikra.Dictionary.EMarker).%KillExtent()
	
	set tSC = ##class(ikra.util.main).DeleteDomain(domName)
	if (tSC '= $$$OK) { write "Can't delete domain :", domName, $System.Status.DisplayError(tSC), ! }
	write "ok", !
	return tSC
}

}

