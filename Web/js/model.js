var translationsRU = {
    MAIN_MENU: {
        F_MARKERS: {
            HEAD: 'ф-Маркеры',
            CATEGORIES: 'Категории',
            CONCEPTS: 'Концепты'
        },
        E_MARKERS: 'э-Маркеры',
        UPLOAD: 'Загрузить',
        DOWNLOAD: { 
            HEAD: 'Сохранить',
            F_MARKERS: 'ф-Маркеры',
            E_MARKERS: 'э-Маркеры'
        },
        DOMAINS: 'Домены',
        GRAPH: 'График',
        USER: 'Пользователь',
        CHANGE_LANG: 'Язык',
        SELECT_LANG_RU: 'РУССКИЙ',
        SELECT_LANG_EN: 'АНГЛИЙСКИЙ'
    },
    CATEGORIES: {
        HEAD: 'Категории',
        CATEGORY: 'Категория',
        ADD_BTN: 'Добавить',
        SAVE_BTN: 'Сохранить'
    },
    CONCEPTS: {
        HEAD: 'Концепты',
        CONCEPT: 'Концепт',
        CATEGORY: '@:CATEGORIES.CATEGORY',
        ADD_BTN: '@:CATEGORIES.ADD_BTN',
        SAVE_BTN: '@:CATEGORIES.SAVE_BTN'
    },
    E_MARKERS: {
        HEAD: 'Эмоциональные маркеры',
        E_MARKER: 'Маркер',
        ADD_BTN: '@:CATEGORIES.ADD_BTN',
        SAVE_BTN: '@:CATEGORIES.SAVE_BTN'
    },
    UPLOAD: {
        HEAD: 'Загрузка данных',
        ADDING: 'Добавить',
        DOWNLOAD_BTN: 'Загрузить',
        F_DICTIONARY: 'функциональный словарь',
        E_DICTIONARY: 'эмоциональный словарь'
    },
    DOMAINS: {
        HEAD: 'Домены',
        DOMAIN: 'Домен',
        CALCULATE_BTN: 'Расчет'
    }
};

var translationsEN = {
    MAIN_MENU: {
        F_MARKERS: {
            HEAD: 'f-Markers',
            CATEGORIES: 'Categories',
            CONCEPTS: 'Concepts'
        },
        E_MARKERS: 'e-Markers',
        UPLOAD: 'Download',
        DOWNLOAD: { 
            HEAD: 'Upload',
            F_MARKERS: 'f-Markers',
            E_MARKERS: 'e-Markers'
        },
        DOMAINS: 'Domains',
        GRAPH: 'Charts',
        USER: 'User',
        CHANGE_LANG: 'Language',
        SELECT_LANG_RU: 'RUSSIAN',
        SELECT_LANG_EN: 'ENGLISH'
    },
    CATEGORIES: {
        HEAD: 'Categories',
        CATEGORY: 'Category',
        ADD_BTN: 'Add',
        SAVE_BTN: 'Save'
    },
    CONCEPTS: {
        HEAD: 'Concetps',
        CONCEPT: 'Concept',
        CATEGORY: '@:CATEGORIES.CATEGORY',
        ADD_BTN: '@:CATEGORIES.ADD_BTN',
        SAVE_BTN: '@:CATEGORIES.SAVE_BTN'
    },
    E_MARKERS: {
        HEAD: 'Emotional markers',
        E_MARKER: 'Marker',
        ADD_BTN: '@:CATEGORIES.ADD_BTN',
        SAVE_BTN: '@:CATEGORIES.SAVE_BTN'
    },
    UPLOAD: {
        HEAD: 'Download data',
        ADDING: 'Adding',
        DOWNLOAD_BTN: 'Download',
        F_DICTIONARY: 'functional dictionary',
        E_DICTIONARY: 'emotional dictionary'
    },
    DOMAINS: {
        HEAD: 'Domains',
        DOMAIN: 'Domain',
        CALCULATE_BTN: 'Calculate'
    }
};


angular.module("app", ['ngRoute', 'pascalprecht.translate'])

.controller('ctrl', ['$scope', '$http', '$translate',

function ctrl($scope, $http, $translate) {

	$scope.cmp = "Выполнить расчет";
	$scope.domName = "";
    $scope.langKey = "RU";
    
    $scope.changeLanguage = function (langKey) {
        $translate.use(langKey);
        $scope.langKey = langKey.toUpperCase();
    };
	
        /***************************************************************************************/
        /********************************* Работа с категориями ********************************/
        /***************************************************************************************/

        //Получить данные по категориям
        $scope.getCategories = function () {
            $http.get("/ikra/json/category").then(
                function (response) {
                    $scope.categories = response.data.children;
		            $scope.ctgSelect = response.data.children[0]["ID"];
		            $scope.getConcepts($scope.ctgSelect);
                },
                function (response, status) {
                    alert("[" + status + "]   Ошибка при загрузке категорий![" + response + "]");
                }
            );
        }

        //Обработка отправки категорий
        $scope.ctggo = function (category) {
            if ($scope.ctgsbm == "ADD_BTN") {
                if (category.CtgName != {} && category.CtgName != null) {
                    $scope.ctgcreate(category);
                }
            } else {
                $scope.ctgsbm = "ADD_BTN";
                $scope.ctgupdate(category);
            }
        }

        //Добавить категорию
        $scope.ctgcreate = function (category) {
            $http.post("/ikra/json/newcategory", category).then(
                function(response) {
                    $scope.getCategories();
                    $scope.alertzone = "Добавили категорию " + category.CtgName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления категории :( [" + response + "]";
                }
            );
        }

        //Обновить категорию
        $scope.ctgupdate = function (category) {
            $http.put("/ikra/json/category/" + category.ID, category).then(
                function (response) {
                    $scope.alertzone = "Обновили категорию " + category.CtgName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + response + "]";
                }
            );
        }

        //Удалить категорию
        $scope.ctgdelete = function (category) {
            $http.delete("/ikra/json/category/" + category.ID).then(
                function (response) {
                    $scope.getCategories();
                    $scope.alertzone = "Удалили категорию " + category.CtgName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления категории :( [" + response + "]";
                }
            );
        }

        //Редактировать категорию
        $scope.ctgedit = function (ctg) {
            $scope.category = ctg;
            $scope.ctgsbm = "SAVE_BTN";
        }

        /***************************************************************************************/
        /********************************* Работа с концептами *********************************/
        /***************************************************************************************/

        //Получить данные по концептам соответствующей категории
        $scope.getConcepts = function (ctgSelect) {
            $http.get("/ikra/json/concept/" + ctgSelect).then(
                function (response) {
                    $scope.concepts = response.data.children;
                },
                function (response, status) {
                    alert("[" + status + "]   Ошибка при загрузке концептов![" + response + "]");
                }
            )
        }

        //Обработка отправки концепта
        $scope.cncptgo = function (concept) {
            if ($scope.cncptsbm == "ADD_BTN") {
                if (concept.FName != {} && concept.FName != null) {
                    $scope.cncptcreate(concept);
                }
            } else {
                $scope.cncptsbm = "ADD_BTN";
                $scope.cncptupdate(concept);
            }
        }

        //Добавить концепт
        $scope.cncptcreate = function (concept) {
            $http.post("/ikra/json/newconcept", concept).then(
                function (response) {
                    $scope.getConcepts($scope.ctgSelect);
                    $scope.alertzone = "Добавили концепт " + concept.FName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления концепта :( [" + response + "]";
                }
            );
        }

        //Обновить концепт
        $scope.cncptupdate = function (concept) {
            $http.put("/ikra/json/concept/" + concept.ID, concept).then(
                function (response) {
                    $scope.alertzone = "Обновили категорию " + concept.FName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + response + "]";
                }
            );
        }

        //Удалить концепт
        $scope.cncptdelete = function (concept) {
            $http.delete("/ikra/json/concept/" + concept.ID).then(
                function (response) {
                    $scope.getConcepts($scope.ctgSelect);
                    $scope.alertzone = "Удалили концепт " + concept.FName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления концепта :( [" + response + "]";
                }
            );
        }

        //Редактировать концепт
        $scope.cncptedit = function (cncpt) {
            $scope.concept = cncpt;
            $scope.cncptsbm = "SAVE_BTN";
        }

//        /***************************************************************************************/
//        /********************************** Работа с эмоциями **********************************/
//        /***************************************************************************************/
//
//        //Получить данные по эмоциональным маркерам
//        $scope.getEmotions = function () {
//            $http.get("/ikra/json/emotion").success(
//                function (data) {
//                    $scope.emotions = data.children;
//                }
//            ).error(
//                function (data, status) {
//                    alert("[" + status + "]   Ошибка при загрузке эмоциональных маркеров![" + data + "]");
//                }
//            )
//        }
//
//        //Обработка отправки эмоционального маркера
//        $scope.emtgo = function (emotion) {
//            if ($scope.emtsbm == "Добавить") {
//                if (emotion.EName != {} && emotion.EName != null) {
//                    $scope.emtcreate(emotion);
//                }
//            } else {
//                $scope.emtsbm = "Добавить";
//                $scope.emtupdate(emotion);
//            }
//        }
//
//        //Добавить эмоциональный маркер
//        $scope.emtcreate = function (emotion) {
//            $http.post("/ikra/json/newemotion", emotion)
//                .success(function (data) {
//                    $scope.getEmotions();
//                    $scope.alertzone = "Добавили концепт " + emotion.EName;
//                }).error(function (data, status) {
//                    $scope.alertzone = "[" + status + "] Ошибка добавления эмоциональных маркеров :( [" + data + "]";
//                });
//        }
//
//        //Обновить эмоциональный маркер
//        $scope.emtupdate = function (emotion) {
//            $http.put("/ikra/json/emotion/" + emotion.ID, emotion)
//                .success(function (data) {
//                    $scope.alertzone = "Обновили эмоциональный маркер " + emotion.EName;
//                }).error(function (data, status) {
//                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + data + "]";
//                });
//        }
//
//        //Удалить эмоциональный маркер
//        $scope.emtdelete = function (emotion) {
//            $http.delete("/ikra/json/emotion/" + emotion.ID)
//                .success(function (data) {
//                    $scope.getEmotions();
//                    $scope.alertzone = "Удалили эмоциональный маркер " + emotion.EName;
//                }).error(function (data, status) {
//                    $scope.alertzone = "[" + status + "] Ошибка удаления эмоционального маркера :( [" + data + "]";
//                });
//        }
//
//        //Редактировать эмоциональный маркер
//        $scope.emtedit = function (emt) {
//            $scope.emotion = emt;
//            $scope.emtsbm = "Сохранить";
//        }

        /***************************************************************************************/
        /********************************** Работа с файлами ***********************************/
        /***************************************************************************************/

        //Загрузка функционального и эмоционального словарей
        $scope.uploadFile = function () {
            var files = document.getElementById('iduplfile').files;
            var uploadUrl = "";
            if ($scope.dictSelect == "uplFunctional") {
                uploadUrl = "/ikra/uploadF";
            } else {
                uploadUrl = "/ikra/uploadE";
            }
            var fd = new FormData();
            fd.append("file", files[0]);

            $http.post(uploadUrl, fd, {
                    withCredentials: true,
                    headers: {
                        'Content-Type': undefined
                    },
                    transformRequest: angular.identity
                }).then(
                    function (response) {
                        console.log('Загружен');
                        document.getElementById('uplstat').innerHTML = 'Успешная загрузка файла!';
                    },
                    function (response, status) {
                        console.log(response);
                        document.getElementById('uplstat').innerHTML = 'Ошибка загрузки файла!';
                    }
                );
        }

        $scope.downloadFile = function (df) {
            var url = df == "F" ? "/ikra/downloadF" : "/ikra/downloadE";
            $http.get(url).then(
                function (response) {
                    console.log(response);
                    var link = document.createElement('a');
                    link.setAttribute('href', response);
                    link.setAttribute('download', 'download');
                    onload = link.click();
                },
                function (response, status) {
                    console.log('Провал');
                }
            )
        }

	/***************************************************************************************/
        /********************************** Работа с доменами **********************************/
        /***************************************************************************************/

	//Получить данные по доменам
        $scope.getDomains = function () {
            $http.get("/ikra/json/domains").then(
                function (response) {
                    console.log(response);
                    $scope.domains = response.data.children;
		    $scope.dmnSelect = response.data.children[0]["ID"];
             console.log(response.data.children);       
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "]   Ошибка при загрузке доменов![" + response + "]";
                }
            )
        }

	//Выполнить расчет
        $scope.compute = function () {
	    console.log($scope.domName);
	    if ($scope.domName.length > 0 && $scope.cmp == "Выполнить расчет") {
		$scope.cmp="Ожидайте окончания расчета";
		$http.post("/ikra/json/compute/" + $scope.domName, "").then(
            function (response) {
                    console.log("Расчет запущен");
		            $scope.cmp = "Выполнить расчет";
            },
            function (response, status) {
                $scope.alertzone = "[" + status + "] Ошибка отправки запроса расчета :( [" + response + "]";
            }
        );
	    }
        }

	$scope.setDomName = function (id) {
		for (var i = 0; i < $scope.domains.length; i++) {
		    if ($scope.domains[i]["ID"] == id) {
			$scope.domName = $scope.domains[i]["dmnName"]; 
			break;
		    }
		}
		console.log($scope.domName);
	}

}
])

.config(function($routeProvider) {
    $routeProvider.when('/category', {
        templateUrl: 'views/category.html',
        controller: 'ctrl'
    })
    .when('/concept', {
        templateUrl: 'views/concept.html',
        controller: 'ctrl'
    })
    .when('/emotion', {
        templateUrl: 'views/emotion.html',
        controller: 'emotionCtrl'
    })
    .when('/upload', {
        templateUrl: 'views/upload.html',
        controller: 'ctrl'
    })
    .when('/domain', {
        templateUrl: 'views/domain.html',
        controller: 'ctrl'
    });
})

.config(['$locationProvider', function($locationProvider) {
  $locationProvider.hashPrefix('');
}])

.config(['$translateProvider', function($translateProvider) {
    $translateProvider.translations('en', translationsEN);
    $translateProvider.translations('ru', translationsRU);
    $translateProvider.preferredLanguage('ru');
    $translateProvider.fallbackLanguage('ru');
}]);