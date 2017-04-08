Class ikra.REST.Broker Extends %CSP.REST
{

XData UrlMap
{
<Routes>

 <Route Url="/category" Method="GET" Call="Category"/>
 
 <Route Url="/json/category" Method="GET" Call="ikra.REST.JSON:GetAllCategories"/>
 <Route Url="/json/newcategory" Method="POST" Call="ikra.REST.JSON:CreateCategory"/>
 <Route Url="/json/category/:catid" Method="DELETE" Call="ikra.REST.JSON:DeleteCategory"/>
 <Route Url="/json/category/:catid" Method="PUT" Call="ikra.REST.JSON:UpdateCategory"/>
 
 <Route Url="/json/concept/:cncptid" Method="GET" Call="ikra.REST.JSON:GetAllConcepts"/>
 <Route Url="/json/newconcept" Method="POST" Call="ikra.REST.JSON:CreateConcept"/>
 <Route Url="/json/concept/:cncptid" Method="DELETE" Call="ikra.REST.JSON:DeleteConcept"/>
 <Route Url="/json/concept/:cncptid" Method="PUT" Call="ikra.REST.JSON:UpdateConcept"/>
 
 <Route Url="/json/emotion" Method="GET" Call="ikra.REST.JSON:GetAllEmotions"/>
 <Route Url="/json/newemotion" Method="POST" Call="ikra.REST.JSON:CreateEmotion"/>
 <Route Url="/json/emotion/:emtid" Method="DELETE" Call="ikra.REST.JSON:DeleteEmotion"/>
 <Route Url="/json/emotion/:emtid" Method="PUT" Call="ikra.REST.JSON:UpdateEmotion"/>
 
 <Route Url="/uploadF" Method="POST" Call="ikra.REST.JSON:UploadFileFunctional"/>
 <Route Url="/uploadE" Method="POST" Call="ikra.REST.JSON:UploadFileEmotion"/>
 <Route Url="/downloadF" Method="GET" Call="ikra.REST.JSON:DownloadFileFunctional"/>
 <Route Url="/downloadE" Method="GET" Call="ikra.REST.JSON:DownloadFileEmotion"/>
 
 <Route Url="/json/domains" Method="GET" Call="ikra.REST.JSON:GetAllDomainNames"/>
 <Route Url="/json/compute/:domName" Method="POST" Call="ikra.REST.JSON:StartCompute"/>
 
 </Routes>
}

ClassMethod Category() As %Status
{
	/*<Route Url="/json/categoryid" Method="GET" Call="ikra.REST.JSON:GetMaxIdCategory"/>*/
    &html<Работает!>
    quit $$$OK
}

}

