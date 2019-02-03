# Seed project for Board framework 

Seed project for full-stack Elm 0.18 application based on [Board](github.com/AIRTucha/board). 

## Back-end

The server is described by *./src/Back.elm*. The key part of server is *router*. It provides access to static files at */public/*. Any unexpected path is forwarded to */index.html*. 

```elm
router : Request value -> Mode String (Answer value model String)
router =
    -- No default actions at empty router
    empty
        -- statically serve files from "./public/"
        |> static any "./public/"   
        -- redirect any unhandled request to "/index.html"                
        |> getSync any (\ _ -> Redirect "/index.html")               
```

The application runs on top of Node.js and it is booted by *./local.js*.

[Board Example application](github.com/AIRTucha/board-demo) demonstrates more sophisticated server based on the library. 

## Front-end

The front-end is described by *./src/Front.elm*. It is represented by a very simple static web page. The simplest meaningful Elm application contains input field, entered value is captured by state and reflected as part of text changed accordingly to user actions. 

The application is loaded by *./public/index.html*.

More complex Elm applications can be found at official Elm documentation.

# Development instructions

The project is powered by *npm* and *Node.js*. 

For installation of dependencies run:

    npm install

For installation of only *Elm* dependencies run: 

    npm run install

For building of back-end application to *./dist/app.js* run:

    npm run back

For building of front-end application to *./public/app.js* run:

    npm run front

For building of entire application with watch run:

    npm start