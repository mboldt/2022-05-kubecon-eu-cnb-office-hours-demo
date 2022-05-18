require 'sinatra'

get '/' do
  '<!DOCTYPE html>
  <html>
    <head>
      <title>Welcome to Buildpacks</title>
    </head>
    <body>
      <img style="display: block; margin-left: auto; margin-right: auto; width: 50%;" src="https://buildpacks.io/images/buildpacks-logo.svg"></img>
    </body>
  </html>'
end
