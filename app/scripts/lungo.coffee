# Start Lungo
Lungo.init
    name: 'Hello Lungo'
    version: '0.1'

Lungo.dom("#submitButton").tap (e) ->
    name = Lungo.dom("#name").val()

    Lungo.dom("#hello-name").html "Hello " + name + "!"

    Lungo.Router.section "hello"

Lungo.dom("nav > button").tap (e) ->
    toSection = Lungo.dom(this).data "view-section"
    toArticle = Lungo.dom(this).data "view-article"

    if toSection
        Lungo.Router.section toSection

    if toArticle
        if not toSection
            parent = $$(this).parent("section")
            toSection = parent.attr("id")
            Lungo.Router.section toSection
        Lungo.Router.article toSection, toArticle
    true