angular.module("app", ['ngRoute'])

.controller('ctrl', ['$scope', '$http',

function ctrl($scope, $http) {

        /***************************************************************************************/
        /********************************* Работа с категориями ********************************/
        /***************************************************************************************/

        //Получить данные по категориям
        $scope.getCategories = function () {
            $http.get("/dictionary/json/category").success(
                function (data) {
                    $scope.categories = data.children;
                }
            ).error(
                function (data, status) {
                    alert("[" + status + "]   Ошибка при загрузке категорий![" + data + "]");
                }
            )
        }

        //Обработка отправки категорий
        $scope.ctggo = function (category) {
            if ($scope.ctgsbm == "Добавить") {
                if (category.CtgName != "" && category.CtgName != null) {
                    $scope.ctgcreate(category);
                }
            } else {
                $scope.ctgsbm = "Добавить";
                $scope.ctgupdate(category);
            }
        }

        //Добавить категорию
        $scope.ctgcreate = function (category) {
            $http.post("/dictionary/json/newcategory", category)
                .success(function (data) {
                    $scope.getCategories();
                    $scope.alertzone = "Добавили категорию " + category.CtgName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления категории :( [" + data + "]";
                });
        }

        //Обновить категорию
        $scope.ctgupdate = function (category) {
            $http.put("/dictionary/json/category/" + category.ID, category)
                .success(function (data) {
                    $scope.alertzone = "Обновили категорию " + category.CtgName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + data + "]";
                });
        }

        //Удалить категорию
        $scope.ctgdelete = function (category) {
            $http.delete("/dictionary/json/category/" + category.ID)
                .success(function (data) {
                    $scope.getCategories();
                    $scope.alertzone = "Удалили категорию " + category.CtgName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления категории :( [" + data + "]";
                });
        }

        //Редактировать категорию
        $scope.ctgedit = function (ctg) {
            $scope.category = ctg;
            $scope.ctgsbm = "Сохранить";
        }

        /***************************************************************************************/
        /********************************* Работа с концептами *********************************/
        /***************************************************************************************/

        //Получить данные по концептам соответствующей категории
        $scope.getConcepts = function (ctgSelect) {
            $http.get("/dictionary/json/concept/" + ctgSelect).success(
                function (data) {
                    $scope.concepts = data.children;
                }
            ).error(
                function (data, status) {
                    alert("[" + status + "]   Ошибка при загрузке концептов![" + data + "]");
                }
            )
        }

        //Обработка отправки концепта
        $scope.cncptgo = function (concept) {
            if ($scope.cncptsbm == "Добавить") {
                if (concept.FName != "" && concept.FName != null) {
                    $scope.cncptcreate(concept);
                }
            } else {
                $scope.cncptsbm = "Добавить";
                $scope.cncptupdate(concept);
            }
        }

        //Добавить концепт
        $scope.cncptcreate = function (concept) {

            $http.post("/dictionary/json/newconcept", concept)
                .success(function (data) {
                    $scope.getConcepts($scope.ctgSelect);
                    $scope.alertzone = "Добавили концепт " + concept.FName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления концепта :( [" + data + "]";
                });
        }

        //Обновить концепт
        $scope.cncptupdate = function (concept) {
            $http.put("/dictionary/json/concept/" + concept.ID, concept)
                .success(function (data) {
                    $scope.alertzone = "Обновили категорию " + concept.FName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + data + "]";
                });
        }

        //Удалить концепт
        $scope.cncptdelete = function (concept) {
            $http.delete("/dictionary/json/concept/" + concept.ID)
                .success(function (data) {
                    $scope.getConcepts($scope.ctgSelect);
                    $scope.alertzone = "Удалили концепт " + concept.FName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления концепта :( [" + data + "]";
                });
        }

        //Редактировать концепт
        $scope.cncptedit = function (cncpt) {
            $scope.concept = cncpt;
            $scope.cncptsbm = "Сохранить";
        }

        /***************************************************************************************/
        /********************************** Работа с эмоциями **********************************/
        /***************************************************************************************/

        //Получить данные по эмоциональным маркерам
        $scope.getEmotions = function () {
            $http.get("/dictionary/json/emotion").success(
                function (data) {
                    $scope.emotions = data.children;
                }
            ).error(
                function (data, status) {
                    alert("[" + status + "]   Ошибка при загрузке эмоциональных маркеров![" + data + "]");
                }
            )
        }

        //Обработка отправки эмоционального маркера
        $scope.emtgo = function (emotion) {
            if ($scope.emtsbm == "Добавить") {
                if (emotion.EName != "" && emotion.EName != null) {
                    $scope.emtcreate(emotion);
                }
            } else {
                $scope.emtsbm = "Добавить";
                $scope.emtupdate(emotion);
            }
        }

        //Добавить эмоциональный маркер
        $scope.emtcreate = function (emotion) {

            $http.post("/dictionary/json/newemotion", emotion)
                .success(function (data) {
                    $scope.getEmotions();
                    $scope.alertzone = "Добавили концепт " + emotion.EName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления эмоциональных маркеров :( [" + data + "]";
                });
        }

        //Обновить эмоциональный маркер
        $scope.emtupdate = function (emotion) {
            $http.put("/dictionary/json/emotion/" + emotion.ID, emotion)
                .success(function (data) {
                    $scope.alertzone = "Обновили эмоциональный маркер " + emotion.EName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + data + "]";
                });
        }

        //Удалить эмоциональный маркер
        $scope.emtdelete = function (emotion) {
            console.log(emotion.ID);
            $http.delete("/dictionary/json/emotion/" + emotion.ID)
                .success(function (data) {
                    $scope.getEmotions();
                    $scope.alertzone = "Удалили эмоциональный маркер " + emotion.EName;
                }).error(function (data, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления эмоционального маркера :( [" + data + "]";
                });
        }

        //Редактировать эмоциональный маркер
        $scope.emtedit = function (emt) {
            $scope.emotion = emt;
            $scope.emtsbm = "Сохранить";
        }

        /***************************************************************************************/
        /********************************** Работа с файлами ***********************************/
        /***************************************************************************************/

        //Загрузка функционального и эмоционального словарей
        $scope.uploadFile = function () {
            var files = document.getElementById('iduplfile').files;
            var uploadUrl = "";
            if ($scope.dictSelect == "uplFunctional") {
                uploadUrl = "/dictionary/uploadF";
            } else {
                uploadUrl = "/dictionary/uploadE";
            }
            var fd = new FormData();
            fd.append("file", files[0]);

            $http.post(uploadUrl, fd, {
                    withCredentials: true,
                    headers: {
                        'Content-Type': undefined
                    },
                    transformRequest: angular.identity
                })
                .success(function (data) {
                    console.log('Загружен');
                    document.getElementById('uplstat').innerHTML = 'Успешная загрузка файла!';
                }).error(function (data, status) {
                    console.log(data);
                    document.getElementById('uplstat').innerHTML = 'Ошибка загрузки файла!';
                });
        }

        $scope.downloadFile = function (df) {
            var url = df == "F" ? "/dictionary/downloadF" : "/dictionary/downloadE";
            $http.get(url).success(
                function (data) {
                    console.log(data);
                    var link = document.createElement('a');
                    link.setAttribute('href', data);
                    link.setAttribute('download', 'download');
                    onload = link.click();
                }
            ).error(
                function (data, status) {
                    console.log('Провал');
                }
            )
        }

}
])

.config(function ($routeProvider) {
    $routeProvider.when('/category', {
        templateUrl: 'views/category.html',
        controller: 'ctrl'
    });
    $routeProvider.when('/concept', {
        templateUrl: 'views/concept.html',
        controller: 'ctrl'
    });
    $routeProvider.when('/emotion', {
        templateUrl: 'views/emotion.html',
        controller: 'ctrl'
    });
    $routeProvider.when('/upload', {
        templateUrl: 'views/upload.html',
        controller: 'ctrl'
    });
});