# Start Lungo
Lungo.init
    name: 'Hello Lungo',
    version: '0.1'

Lungo.dom("#submitButton").tap (e) ->
        name = Lungo
            .dom("#name")
            .val()

        Lungo
            .dom("#hello-name")
            .html "Hello " + name + "!"

        Lungo
            .Router
            .section "hello"
