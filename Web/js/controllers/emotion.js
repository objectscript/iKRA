angular.module("app")

.controller('emotionCtrl', ['$scope', '$http',

function emotionCtrl($scope, $http) {
    
    /***************************************************************************************/
        /********************************** Работа с эмоциями **********************************/
        /***************************************************************************************/

        //Получить данные по эмоциональным маркерам
        $scope.getEmotions = function () {
            $http.get("/ikra/json/emotion").then(
                function (response) {
                    $scope.emotions = response.data.children;
                },
                function (response, status) {
                    alert("[" + status + "]   Ошибка при загрузке эмоциональных маркеров![" + response + "]");
                }
            )
        }

        //Обработка отправки эмоционального маркера
        $scope.emtgo = function (emotion) {
            if ($scope.emtsbm == "ADD_BTN") {
                if (emotion.EName != "" && emotion.EName != null) {
                    $scope.emtcreate(emotion);
                }
            } else {
                $scope.emtsbm = "ADD_BTN";
                $scope.emtupdate(emotion);
            }
        }

        //Добавить эмоциональный маркер
        $scope.emtcreate = function (emotion) {
            $http.post("/ikra/json/newemotion", emotion).then(
                function (response) {
                    $scope.getEmotions();
                    $scope.alertzone = "Добавили концепт " + emotion.EName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка добавления эмоциональных маркеров :( [" + response + "]";
                }
            );
        }

        //Обновить эмоциональный маркер
        $scope.emtupdate = function (emotion) {
            $http.put("/ikra/json/emotion/" + emotion.ID, emotion).then(
                function (response) {
                    $scope.alertzone = "Обновили эмоциональный маркер " + emotion.EName;
                },
                function (response, status) {
                    $scope.alertzone = "[" + status + "] Ошибка обновления имени категории :( [" + response + "]";
                }
            );
        }

        //Удалить эмоциональный маркер
        $scope.emtdelete = function (emotion) {
            $http.delete("/ikra/json/emotion/" + emotion.ID).then(
                function (response) {
                    $scope.getEmotions();
                    $scope.alertzone = "Удалили эмоциональный маркер " + emotion.EName;
                },
                function (dresponseata, status) {
                    $scope.alertzone = "[" + status + "] Ошибка удаления эмоционального маркера :( [" + response + "]";
                }
            );
        }

        //Редактировать эмоциональный маркер
        $scope.emtedit = function (emt) {
            console.log(emt);
            $scope.emotion = emt;
            $scope.emtsbm = "SAVE_BTN";
        }
    
}])