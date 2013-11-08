var App = (function (lng) {
    lng.App.init({
        name: 'Hello Lungo',
        version: '0.1'
    });
})(LUNGO);

App.Events = (function (lng) {
    lng.dom("#submitButton").tap(function (event) {
        var name = lng.dom("#name").val();
        lng.dom("#hello-name").html("Hello " + name + "!");
        lng.Router.section("hello");
    });
})(LUNGO);