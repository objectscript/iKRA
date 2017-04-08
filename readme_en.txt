Installation of the system:
1. Expose the iKRA.xml file in the required area <your area>.
2. In the system management portal (System Administration -> Security -> Applications -> Web Applications), create the application for the default scope.
	Settings
	Name: /csp/ikra
	Area: <your area>
	The physical path to the CSP files: we specify our <path for the web application>
Saving.
3. Go to the "Application Roles" tab and assign the %All role.
Saving.
4. In the portal of system management (System administration -> Security -> Applications -> Web applications), we create new application.
	Settings
	Name: /ikra
	Scope: <your area>
	Handler class: ikra.REST.Broker
Saving.
5. Go to the "Application Roles" tab and assign the role of %All.
Saving.
6. Copy files from the Web folder to <path for web application>.
7. In the ikra.REST.JSON class, in the DownloadFileFunctional() and DownloadFileEmotion() methods, set the desired path for saving the file before sending it to the sFolder variable.
For DownloadFileFunctional() "<path for web application>\files\functional.txt"
For DownloadFileEmotion() "<path for web application>\files\emotion.txt"
8. Files from the folder Load are copied to any place <files load>.
9. In the Sources.txt file, replace the "D:\intersystems\wPhones\" with "load files".
10. In the ikra.Phones.Loader class in the Load method, set domFolder As %String = "D:\intersystems\wPhones\" to the default value of domFolder As% String = "<files load>".

Starting the system:
1. Download the functional dictionary (Fmarkers.txt file) and the emotional dictionary (Emarkers.txt file) via the web application.
2. In the terminal, execute the command: do ##class(ikra.Phones.Loader).Load("<domain name>")
(To remove the domain: do ##class(ikra.Phones.Loader).Free("<domain name>")).
3. Start the calculation process do ##class(ikra.Phones.Processing.Processing).Start("<domain name>").
4. In the system management portal (System Explorer -> SQL), to view the results of the objects to be examined, execute the query:
	Select unt.uid, unt.uname, ctg.ctgname, unt.mark
	From ikra_dictionary.marksunit unt
	Join ikra_dictionary.category ctg on unt.ctgid = ctg.id
	Union all
	Select distinct uid, '', '', null
	From ikra_dictionary.marksunit
	Order by 1
5. In the system management portal (System Explorer -> SQL), to view the results of the reviews, execute the query:
	Select unt.uid, rwt.rid, unt.uname, ctg.ctgname, rwt.mark
	From ikra_dictionary.marksreview rwt
	Join ikra_dictionary.marksunit unt on rwt.uid = unt.id
	Join ikra_dictionary.category ctg on rwt.ctgid = ctg.id
	Where rwt.mark is not null
	Union all
	Select distinct unt.uid, rwt.rid, '', '', null
	From ikra_dictionary.marksreview rwt
	Join ikra_dictionary.marksunit unt on rwt.uid = unt.id
	Join ikra_dictionary.category ctg on rwt.ctgid = ctg.id
	Where rwt.mark is not null
	Order by 2