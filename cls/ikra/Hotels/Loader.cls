Include %IKPublic

/// Class to load hotel data from globals, create iKnow domain for use in iKRA
Class ikra.Hotels.Loader
{

// do ##class(ikra.Hotels.Loader).Free("Hotels")

// do ##class(ikra.Hotels.Loader).Load("Hotels","/tmp/Load/Hotels",1,100)

ClassMethod Load(domName As %String, domFolder As %String, FromId As %Integer = 1, ToId As %Integer = 0) As %Status
{
	
	// Check the input parameters for validity
	if (((ToId '= 0) & (FromId > ToId)) || (FromId <= 0) || (ToId < 0)) 
	{
		write "Wrong parameters FromID|ToID.", !	
		return $$$ERROR()
	}

	write "Loading started at: ", $zdatetime($horolog), !
	
	// If the domain does not exist, create a new (also creating a configuration)
	do ##class(ikra.util.main).CreateDomainIfNotExists(domName, domFolder)
	set domId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	// Set the name of configuration	
	#dim confName As %String = "Conf"_domName
	
	set lister = ##class(%iKnow.Source.SQL.Lister).%New(domId)
	do lister.SetConfig(confName)	
	#dim initialNumOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)
	
	
	set loader = ##class(%iKnow.Source.Loader).%New(domId)
	
	// Crating the Metadata fields	
	do ..SetMetaDataFields(domName)	
	
	set myquery = "SELECT ID1 As ID, hotel_id as UnitId, hotel_name As UnitName, review_text as reviewText,"_
				  " rating as AuthorRating FROM Nui.hreview"
	
	// Form a query in accordance with the input parameters
	if (ToId > 0) 						{ set myquery = myquery_" Where ID1 >= "_FromId_" AND ID1 <= "_ToId }
	elseif ((FromId > 1) && (ToId = 0)) { set myquery = myquery_" Where ID1 >= "_FromId }
	
	// Forming batch
	// =================
	set meta = $lb("UnitId", "UnitName", "AuthorRating")
	set data = $lb("reviewText")
	set group = "ID"
	set id = "ID"
	
	set tSC = lister.AddListToBatch(myquery, id, group, data, meta)
    
    if (tSC '= $$$OK) { 
    	write "The lister failed: ",$System.Status.DisplayError(tSC)
    	return tSC 
    }
    // =================
      
    write "Adding List to Batch Complete!", !
    	
    set tSC = loader.ProcessBatch()      
    
    // In the event of an error, the process should not be interrupted, since errors can be harmless.
    if (tSC '= $$$OK) { 
    	write "The loader failed: ", $System.Status.DisplayError(tSC) 
    }
    
	#dim numOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)
	
	write !, "Loading finished at: ", $zdatetime($horolog), !
			
	write !, "Initial Number of Sources: ", initialNumOfSources, !
	write "Sources Added: ", numOfSources - initialNumOfSources, !
	write "Total: ", numOfSources,!
		
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
	
	set tSC = ##class(%iKnow.Queries.MetadataAPI).RemoveField(domainId, "UnitId")
	set tSC = tSC + ##class(%iKnow.Queries.MetadataAPI).RemoveField(domainId, "UnitName")
	set tSC = tSC + ##class(%iKnow.Queries.MetadataAPI).RemoveField(domainId, "AuthorRating")
	
	if (tSC = 3) { write "all metadata fields are deleted", ! }
	else { write "errors in deleting metadata fields", ! }
		
	return tSC
}

/// Method of deleting a domain with all environment
ClassMethod Free(domName As %String) As %Status
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

	set tSC = ##class(ikra.util.main).DeleteDomain(domName)
	if (tSC '= $$$OK) { write "Can't delete domain :", domName, $System.Status.DisplayError(tSC), ! }
	write "ok", !
	return tSC
}

}

