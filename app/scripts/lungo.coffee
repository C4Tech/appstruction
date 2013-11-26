# Start Lungo
Lungo.init
    name: 'Hello Lungo'
    version: '0.1'

navLink = (e) ->
    toSection = Lungo.dom(this).data "view-section"
    toArticle = Lungo.dom(this).data "view-article"

    if toSection
        Lungo.Router.section toSection
    else
        parent = Lungo.dom(this).parent "section"
        toSection = parent.attr "id"

    if toArticle
        Lungo.Router.article toSection, toArticle
    e

Lungo.dom("button.link").tap navLink
Lungo.dom("a").tap navLink

Lungo.dom("#submitButton").tap (e) ->
    name = Lungo.dom("#name").val()
    Lungo.dom("#hello-name").html "Hello " + name + "!"
    Lungo.Router.section "hello"

