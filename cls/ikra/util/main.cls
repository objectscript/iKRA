Include %IKPublic

/// general functions of iKnow domain creation
Class ikra.util.main Extends %XML.Adaptor
{

/// Сохдание нового домена и конфигурации
/// domName - имя создаваемого домена, используется также при создании конфигурации с приставкой "conf",
/// domFolder - имя папки, где находятся файлы словарей, используемых при создании домена (пример пути "D:\intersystems\wPhones\")
ClassMethod Create(domName As %String, domFolder As %String) As %Status
{
	/* установка заначения пути к файлам словарей для домена, 
	выполняется 1 раз при создании домена, в последствии может быть заменена только вручную */
	
	set ^ikraDomainFolder(domName) = domFolder
	set ^ikraDomainFolder(domName,"loadNumber") = 0
	
	#dim confName As %String = "Conf"_domName
	#dim domain As %iKnow.Domain = ..CreateDomain(domName)
	#dim domId As %Integer = ..GetDomainId(domName)
	 
	if '($data(domId)) { return $$$ERROR("Domain does not exist.") }
	 
	write "ID of new domain: ", domId,!
	
	// Конфигурация создается для листера	
	#dim configuration As %iKnow.Configuration = ..CreateConfiguration(domName, confName) 
	
	return $$$OK
}

// =================================================================================================

// =================================================================================================

/// Загрузка домена из файлов указанной директории
/// добавляет новые статьи в уже существующий домен, обновляет словари по актуальным версиям файлов
/// возвращает количество добавленных статей
/// domName - имя создаваемого домена, используется также при создании конфигурации с приставкой "conf", 
/// для обновления домена используются файлы: 
/// 1. Sources.txt - список загружаемых rss-лент
/// 2. Dictionary.txt -  список проверочных слов и выражений для разделения статей по темам
/// 3. BlackList.txt - список слов и выражений, которые не будут распознаваться как концепты
/// 4. Emotions.txt - список основ слов, характеризующих эмоциональную окраску статей
/// Все файлы находятся в папке ^ikraDomainFolder(domName)
/// writeLog - флаг записи лог-файла при обновлении. Log-файл с именем updateLog.txt в рабочем каталоге домена
ClassMethod LoadFile(domName As %String, domFolder As %String, sourceFilesPath As %String) As %Integer
{

	// Если домен не существует, создаем новый (так же создается конфигуация)	
	do ..CreateDomainIfNotExists(domName, domFolder)
	
	#dim confName As %String = "Conf"_domName
	#dim domId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	#dim initialNumOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)
	#dim listerFile As %iKnow.Source.File.Lister = ..CreateListerFile(domName, confName)				// листер File
	#dim loader As %iKnow.Source.Loader = ..CreateLoader(domName)	// лоадер создается для домена
	
	// Создаем словари для matching
	do ..CreateDictionaries(domName)
	// Формируем черные списки							
	//do ..CreateBlackLists(domName, "GeneralBlackList")			
	
	// Добавляем файл в список на обработку
	// 3 параметр - смотреть в подпапках, 4 - фильтр
	set status = listerFile.AddListToBatch(sourceFilesPath, $lb("txt"), 0, "") 
	
	// Если что-то не так, выдаем текст ошибки
	if '(status = $$$OK) 
	{ 
		zwrite status
	}
	
	// Запускаем обработку
	set status = loader.ProcessBatch()

	// Если что-то не так, выдаем текст ошибки	
	if '(status = $$$OK) 
	{
		zwrite status
	}
		
	// Матчим источники
	write "   matching sources...",!
	set status = ##class(%iKnow.Matching.MatchingAPI).MatchSources(domId)
		
	if (status = $$$OK)
	{
		write "   sources are matched",!	
	}
	else
	{
		write "Error, matching sources", status, !
	}		
		
	#dim numOfSources As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domId)

	// Статистика загруженных источников (было, загружено, стало)	
	write "Initial number of sources : ", initialNumOfSources,!
	write "Sources Added : ", numOfSources - initialNumOfSources,!
	write "Total : ", numOfSources,!
		
	return (numOfSources - initialNumOfSources)
}

// =================================================================================================

// =================================================================================================

// =================================================================================================

/// Удаление домена со всем окружением
/// domName - имя домена
ClassMethod Free(domName As %String) As %Status
{
	k ^ikraDomainFolder(domName)
	#dim confName As %String = "Conf"_domName

	// Удалаем поля метаданных	
	do ..RemoveMetaDataFields(domName)		
	// Удаляем словари для matching	
	do ..DeleteDictionaries(domName)
	// Удаляем черные списки				
	//do ..DeleteBlackLists(domName, "GeneralBlackList")	
	// Удаляем конфигурацию
	#dim status As %Status = ..DeleteConfiguration(confName)
	
	if (status '= $$$OK)	
	{	
		write "Cannot delete configuration :", confName, !	
	}
	
	// Удаляем домен
	set status = ..DeleteDomain(domName)
	
	if (status '= $$$OK)	
	{	
		write "Cannot delete configuration :", confName, !	
	}
	
	return status
}

// =================================================================================================

/// Выводит в консоль основную информацию о домене
ClassMethod PrintDomainInfo(domName As %String) As %Status
{
	
	if (##class(%iKnow.Domain).Exists(domName))
	{
		#dim domainID As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	}
	else
	{
		write "   domain ",domName," does not exist",!
	}	
	
	#dim sourceNumber As %Integer = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainID)
	
	
	write "   domain name   = ", domName, !
	write "   domain ID     = ", domainID, !
	write "   domain folder = ", ^ikraDomainFolder(domName), !
	write "   sources       = ", sourceNumber, !
	
	return $$$OK
}

// =================================================================================================

/// Создание нового домена
/// domName - имя создаваемого домена
ClassMethod CreateDomain(domName As %String) As %iKnow.Domain
{
	if (##class(%iKnow.Domain).Exists(domName))
	{
		#dim domain As %iKnow.Domain = ##class(%iKnow.Domain).Open(domName)
		write "   open domain ", domName, " ", !
	}
	else
	{
		set domain = ##class(%iKnow.Domain).%New(domName)
		do domain.%Save()
		do domain.SetParameter($$$IKPSTEMMING, 1)
		write "   stemming is ON",!	
		do domain.%Save()		
		write "   domain ", domName, " created!", !
	}
	return domain
}

// =================================================================================================

/// Удаление домена со всеми данными
/// domName - имя удаляемого домена
ClassMethod DeleteDomain(domName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domain  = ##class(%iKnow.Domain).Open(domName)
		set domainId = domain.Id
		set tSC = ##class(%iKnow.Domain).DeleteId(domainId)	
		
		if (tSC = $$$OK) {
			write "Domain ", domName, " deleted successfully.", !
			return $$$OK
		}
		else {
			write "Error: failed to delete domain ", domName, !
			return $$$ERROR()
		}
	}
	else {
		write "Domain ", domName, " doesn't exist", !
		return $$$ERROR()
	}
}

// =================================================================================================

/// Создание конфигурации, используется при создании листера
/// domName - имя текущего домена
/// confName - имя создаваемой конфигурации
ClassMethod CreateConfiguration(domName As %String, confName As %String) As %iKnow.Configuration
{
	if (##class(%iKnow.Configuration).Exists(confName))
	{
		#dim configuration AS %iKnow.Configuration = ##class(%iKnow.Configuration).Open(confName)
		write "   open congiguration ",confName," ",!
	}
	else
	{
		//#dim filename As %String = ^ikraDomainFolder(domName)_"Substitution.txt"
		
		/*set userDictionaryName = "MyUserDict" 
		
		set udict = ..CreateUserDictionary(userDictionaryName)*/
	
		//s configuration = ##class(%iKnow.Configuration).%New(confName,0,"ru",udict.Name,1)
		s configuration = ##class(%iKnow.Configuration).Create(confName,0,"ru")
		//set configuration = ##class(%iKnow.Configuration).%New(confName,1,$lb("en","ru"),filename,1)		
		//s configuration = ##class(%iKnow.Configuration).%New(confName,0,"ru")
		//set configuration.StemmingConfig = "DEFAULT"
		do configuration.%Save()
		write "   configuration ",confName," created!",!
	}
	
	return configuration
}

// =================================================================================================

/// Удаление конфигурации
/// confName - имя удаляемой конфигурации
ClassMethod DeleteConfiguration(confName As %String) As %Status
{
	if (##class(%iKnow.Configuration).Exists(confName))
	{
		#dim configuration As %iKnow.Configuration = ##class(%iKnow.Configuration).Open(confName)
		#dim configurationId As %Integer = configuration.Id
		#dim status As %Status = ##class(%iKnow.Configuration).DeleteId(configurationId)
		
		if (status = $$$OK)
		{
			write "   configuration ",confName," deleted",!
			return $$$OK
		}
		else
		{
			write "   Error: failed to delete configuration ",confName,!
			return $$$ERROR()
		}
	}
	else
	{
		write "   configuration ",confName," doesn't exist",!
		return $$$OK
	}
}

// =================================================================================================

/// Создание лоадера, создается для домена (по имени домена)
/// domName - имя домена, для которого создается загрузчик
ClassMethod CreateLoader(domName As %String) As %iKnow.Source.Loader
{
	if (##class(%iKnow.Domain).Exists(domName)) 
	{
		#dim domainId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} 
	else 
	{
		write "Error: domain " + domName + " not found"
		return NULL
	}
	
	#dim loader As %iKnow.Source.Loader = ##class(%iKnow.Source.Loader).%New(domainId)	

	return loader
}

// =================================================================================================

/// Создание файлового листера, создается для домена (по имени домена)
/// domName - имя домена, для которого создается листер
/// confName - имя конфигурации, которая будет применяться в листере
ClassMethod CreateListerFile(domName As %String, confName As %String, converter As %Integer = 1) As %iKnow.Source.File.Lister
{
	if (##class(%iKnow.Domain).Exists(domName)) 
	{
		#dim domainId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} 
	else 
	{
		write "Error: domain " + domName + " not found"
		return NULL
	}
	
	#dim lister As %iKnow.Source.File.Lister = ##class(%iKnow.Source.File.Lister).%New(domainId)	
	
	do lister.SetConfig(confName)
	
	write "   lister created!",!
	
	return lister
}

// =================================================================================================

/// Установка дополнительных полей метаданных для статей, возвращает количество созданных полей данных
/// domName - имя домена, в котором проводится действие
/// редактировать совместно с ..RemoveMetaDataFields
ClassMethod SetMetaDataFields(domName As %String) As %Integer
{
	#Include %IKPublic	
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return 0
	}	
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"PubDate",,$$$MDDTDATE )
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"Title",,$$$MDDTSTRING )
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"Link",,$$$MDDTSTRING )
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"Agency",,$$$MDDTSTRING )	
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"Topic",,$$$MDDTSTRING )
	set val = ##class(%iKnow.Queries.MetadataAPI).AddField( domainId,"Category",,$$$MDDTSTRING )
	
	// 1 is standard DataIndexed, plus 6 added manually
	if (val = 7)
	{
		write "all metadata fields are created - total ", val, !
	}
	else
	{
		write "errors creating metadata fields - total ", val, !
	}
	return val
}

// =================================================================================================

/// Удаление дополнительных полей, используется при обновлении и удалении домена, возвращает число удаленных полей
/// domName - имя домена, в котором проводится действие
/// редактировать совместно с ..SetMetaDataFields
ClassMethod RemoveMetaDataFields(domName As %String) As %Integer
{
	if (##class(%iKnow.Domain).Exists(domName)) 
	{
		#dim domainId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} 
	else 
	{
		write "Error: domain " + domName + " not found"
		return 0
	}
	
	#dim status As %Status = ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"PubDate" )
	set status = status + ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"Title" )
	set status = status + ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"Link" )
	set status = status + ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"Agency" )
	set status = status + ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"Topic" )
	set status = status + ##class(%iKnow.Queries.MetadataAPI).RemoveField( domainId,"Category" )
	
	if (status = 6)
	{
		write "all metadata fields are deleted",!
	}
	else
	{
		write "errors in deleting metadata fields",!
	}
		
	return status
}

// =================================================================================================

/// создание словарей по файлу, путь к файлу ^ikraDomainFolder(domName) + "Dictionary.txt"
/// domName - имя домена, в котором проводится действие
/// формат файла, идентификаторы строк: "!" - комментарий, "d" - словарь, "i"-группа терминов, "t"-термин
ClassMethod CreateDictionaries(domName As %String) As %Status
{
	
	if (##class(%iKnow.Domain).Exists(domName)) 
	{
		#dim domainId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} 
	else 
	{
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	#dim filename As %String = ^ikraDomainFolder(domName)_"Dictionary.txt"
	#dim stream As %Stream.FileCharacter = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(filename)
	
	set i = 0
	
	#dim dictId = 0
	#dim itemId = 0
	#dim language = 0
		
	while '(stream.AtEnd) 
	{		
		set line = stream.ReadLine()
		
		// проверка строки на комментарий (начинается с !)		
		set checkComment = $PIECE(line,"!",1,1)
		if (checkComment="") {continue}
		
		// обработка строки
		set stype = $piece(line,"#",1)
		set i = i + 1
		
		if (stype="d") 
		{
			// добавляем словарь
			set language = $piece(line,"#",4)
			set dictId = ##class(%iKnow.Matching.DictionaryAPI).CreateDictionary( domainId, $piece(line,"#",2), $piece(line,"#",3),language,"",.status )
			write "   dictionary ", $piece(line,"#",2), " created",!
		}		// elseif (stype="d")
		elseif (stype="i") 
		{
			// добавляем item
			set ref = ""
			set itemId = ##class(%iKnow.Matching.DictionaryAPI).CreateDictionaryItem( domainId, dictId, $piece(line,"#",2), .ref, language)
		}		// elseif (stype="i")
		elseif (stype="t") 
		{
			// парсим строку с терминами, разделенными запятой
			set dList = $piece(line,"#",2)
			set j = 1
			while $piece(dList,",",j)'="" 
			{	
				set termId = ##class(%iKnow.Matching.DictionaryAPI).CreateDictionaryTerm( domainId, itemId, $piece(dList,",",j), language)	
				set j = j + 1
			}
		}		// elseif (stype="t")
	}		// 'stream.AtEnd
			
	return $$$OK
}

// =================================================================================================

/// удаление словарей
/// domName - имя домена, в котором проводится действие
ClassMethod DeleteDictionaries(domName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	do ##class(%iKnow.Matching.DictionaryAPI).DropAllDictionaryData(domainId)
	write "   all dictionaries are deleted",!
	return $$$OK
}

// =================================================================================================

/// обновление словарей, вместо старых словарей формируются новые по файлу dictionary.txt, затем проводится переиндексация статей в домене
/// domName - имя домена, в котором проводится действие
ClassMethod UpdateDictionaries(domName As %String) As %Status
{
	do ..DeleteDictionaries(domName)			// удаляем словари для matching
	do ..CreateDictionaries(domName)			// создаются словари для matching
	
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
		
	write "   matching sources...",!
	set status = ##class(%iKnow.Matching.MatchingAPI).MatchSources(domainId)	
	if (status = 1)
	{
		write "   sources are matched",!	
	}
	else
	{
		write "Error, matching sources", status, !	
	}
	set numOfSources = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainId)
	write "Sources Loaded : ", numOfSources,!
	
	return $$$OK
}

// =================================================================================================

/// Метод создаёт черные списки по файлу BlackList.txt, 
/// содержит построчно перечисленные термины, "!" - в начале строки символ комментария
/// domName - имя домена, в котором проводится действие
/// BLName - имя формируемого в домене черного списка
ClassMethod CreateBlackLists(domName As %String, BLName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	set blackListId = ##class(%iKnow.Utils.MaintenanceAPI).CreateBlackList(domainId, BLName)
	
	set filename = ^ikraDomainFolder(domName)_"BlackList.txt"
	set stream = ##class(%Stream.FileCharacter).%New()
	set sc = stream.LinkToFile(filename)
	
	while 'stream.AtEnd {		
		set line = stream.ReadLine()
		
		// порверка строки на комментарий, определяется "!" в начале строки
		set checkComment = $PIECE(line,"!",1,1)
		if (checkComment="") {continue}
		
		set sc = ##class(%iKnow.Utils.MaintenanceAPI).AddStringToBlackList(domainId, blackListId, line)
		write "   line: ",line," added to black list",!
	}

	return $$$OK
}

// =================================================================================================

/// Метод удаляет черный список
/// domName - имя домена, в котором проводится действие
/// BLName - имя удаляемого в домене черного списка
ClassMethod DeleteBlackLists(domName As %String, BLName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	if ( 0 = ##class(%iKnow.Utils.MaintenanceAPI).HasBlackLists(domName) )
	{
		write "   no black lists found",!
		return $$$OK	
	}
	set blackListId = ##class(%iKnow.Utils.MaintenanceAPI).GetBlackListId(domainId, BLName)
	set sc = ##class(%iKnow.Utils.MaintenanceAPI).DropBlackList(domainId, blackListId)
	
	if (sc=$$$OK)
	{	
		write "   black list deleted",!}
	else 
	{
		write "Error deleting black list",!
		write sc,!
	}
	
	return $$$OK
}

// =================================================================================================

/// Метод обновляет или создаёт черные списки по файлу BlackList.txt, 
/// содержит построчно перечисленные термины, "!" - в начале строки символ комментария
/// domName - имя домена, в котором проводится действие
/// BLName - имя формируемого в домене черного списка
ClassMethod UpdateBlackLists(domName As %String, BLName As %String) As %Status
{
	if (##class(%iKnow.Domain).Exists(domName)) {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(domName)
	} else {
		write "Error: domain " + domName + " not found"
		return $$$ERROR()
	}
	
	set sc = ..DeleteBlackLists(domName, BLName)
	if (sc = $$$OK)
	{
		write "BlackList ",BLName, " deleted",!	
	}
	
	set sc = ..CreateBlackLists(domName, BLName)
	if (sc = $$$OK)
	{
		write "BlackList ",BLName, " created",!	
	}	

	return $$$OK
}

// =================================================================================================

/// Метод, возвращающий DomainId по имени домена.
/// domName - имя домена.
ClassMethod GetDomainId(domName As %String) As %Integer
{
	// Проверяем, существует ли домен. 
	// Если да - возвращаем id.
	// Если нет - выдаем ошибку, что такого домена нет.
	if (##class(%iKnow.Domain).Exists(domName)) 
	{
		#dim domId As %Integer = ##class(%iKnow.Domain).GetOrCreateId(domName)
	}
	else 
	{
		write "Error: domain " + domName + " not found"
		return ""
	}
	 
	return domId
}

/// Метод инициализации домена.
/// Если домен не существует, создаем новый с конфигурацией по указанной папке.
/// Вызывается в методах LoadRSS(), LoadDomain(), LoadFile(), TransferDomain()
/// domName - имя домена
/// domFolder - путь к папке домена
ClassMethod CreateDomainIfNotExists(domName As %String, domFolder As %String)
{
	if '(##class(%iKnow.Domain).Exists(domName)) 
	{
		write "Domain " _ domName _ " does not exist.", !
		
		if '($data(domFolder)) 
		{
			write "Please, specify the domain folder.", !
			write "Ex.: Load(""MyDomain"", ""D:\intersystems\wPhones\Example\"")", !
			
			return $$$ERROR("The domain's folder does not specified.")
		}
		else 
		{
			write "Creating new domain: " _ domName, !
				
			#dim status As %Status = ..Create(domName, domFolder)
			
			if (status = $$$OK) 
			{
				write "New domain " _ domName _ " was created successfully.", !	
			}
			else 
			{
				return status
			}
		}	
		
	}
}

/// Метод, производящий инициализацию пользовательского словаря
/// userDictionaryName - имя пользовательского словаря
ClassMethod CreateUserDictionary(userDictionaryName As %String) As %iKnow.UserDictionary
{
		
		// Пробуем открыть существующий словарь
		set udict = ##class(%iKnow.UserDictionary).OpenByName(userDictionaryName) 
		
		// Если получилось, то удаляем его 
		// (так как мы не знаем, что в нем содержится, лучше создать новый)
		if (udict '= "")
		{
			do ##class(%iKnow.UserDictionary).%DeleteId(udict.Id)
		}
		
		// Создаем новый словарь
		set udict = ##class(%iKnow.UserDictionary).%New(userDictionaryName) 
		do udict.%Save()
		
		// Заполняем словарь элементами
		do udict.AddEntry("))))",".")
		do udict.AddEntry(")))",".")
		do udict.AddEntry("))",".")
		do udict.AddEntry(". ",".")
		do udict.AddEntry(".....",".")
		do udict.AddEntry("...",".")
		do udict.AddEntry("..",".")
		do udict.AddEntry(".",". ")
		do udict.AddEntry("!!!!!","!")
		do udict.AddEntry("!!!","!")
		do udict.AddEntry("!!","!")
		do udict.AddEntry("!","! ")
		do udict.AddEntry("?????","?")
		do udict.AddEntry("???","?")
		do udict.AddEntry("??","?")
		do udict.AddEntry("?","? ")
		do udict.AddEntry(",",", ")
		
		//Сохраняем словарь
		do udict.%Save()
		
		write "UserDictionary created!", !
		
		return udict
}

// ===========================================================================================

Storage Default
{
}

}

