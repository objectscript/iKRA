Установка системы:
1. Экспоритруем файл iKRA.xml в нужную область <ваша область>.
2. В портале управления системой (Администрирование системы -> Безопасность -> Приложения -> Веб приложения) создаем приложение для области по умолчанию.
	Установоки
	Имя: /csp/default
	Область: <ваша область>
	Физический путь к CSP-файлам: указываем свой <путь для веб-приложения> (у меня C:\InterSystems\Ensemble\CSP\default\)
	И не забываем поставить галочку "Приложение для области по умолчанию"!
Сохраняем.
3. Переходим на вкладку "Роли приложений" и назначаем роль %All.
Сохраняем.
4. В портале управления системой (Администрирование системы -> Безопасность -> Приложения -> Веб приложения) создаем еще одно приложение.
	Установоки
	Имя: /dictionary
	Область: <ваша область>
	Класс-обработчик: iknowAL.REST.Broker
Сохраняем.
5. Переходим на вкладку "Роли приложений" и назначаем роль %All.
Сохраняем.
6. Копируем файлы из папки Web по адресу <путь для веб-приложения>.
7. В классе iknowAL.REST.JSON в методах DownloadFileFunctional() и DownloadFileEmotion() устанавливаем желаемый путь сохранения файла перед отправкой пользователю в переменную sFolder.
Для DownloadFileFunctional() "<путь для веб-приложения>\files\functional.txt"
Для DownloadFileEmotion() "<путь для веб-приложения>\files\emotion.txt"
8. Файлы из папки Load копируем в любое место <файлы load>.
9. В файле Sources.txt сделать замену счтроки "D:\intersystems\wPhones\" на <файлы load>.
10. В классе iknowAL.Phones.Loader в методе Load в значении по умолчанию параметра domFolder As %String = "D:\intersystems\wPhones\" выставить domFolder As %String = "<файлы load>".

Запуск системы:
1. Через веб-приложение загрузить функциональный словарь (файл Fmarkers.txt) и эмоциональный словарь (файл Emarkers.txt).
2. В терминале выполнить команду: do ##class(iknowAL.Phones.Loader).Load("<имя домена>")
(для удаления домена: do ##class(iknowAL.Phones.Loader).Free("<имя домена>")).
3. Запустить процесс вычисления do ##class(iknowAL.Phones.Processing.Processing).Start("<имя домена>").
4. В портале управления системой (Обозреватель системы -> SQL) для  просмотра результатов по исследуемым объектам выполнить запрос:
	select unt.uid, unt.uname, ctg.ctgname, unt.mark
	from iknowal_dictionary.marksunit unt
	join iknowal_dictionary.category ctg on unt.ctgid = ctg.id
	union all
	select distinct uid, '', '', null
	from iknowal_dictionary.marksunit
	order by 1
5. В портале управления системой (Обозреватель системы -> SQL) для  просмотра результатов по отзывам выполнить запрос:
	select unt.uid, rwt.rid, unt.uname, ctg.ctgname, rwt.mark
	from iknowal_dictionary.marksreview rwt
	join iknowal_dictionary.marksunit unt on rwt.uid = unt.id
	join iknowal_dictionary.category ctg on rwt.ctgid = ctg.id
	where rwt.mark is not null
	union all
	select distinct unt.uid, rwt.rid, '', '', null
	from iknowal_dictionary.marksreview rwt
	join iknowal_dictionary.marksunit unt on rwt.uid = unt.id
	join iknowal_dictionary.category ctg on rwt.ctgid = ctg.id
	where rwt.mark is not null
	order by 2