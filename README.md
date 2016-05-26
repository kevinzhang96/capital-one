# Cash Dash
Parse setup tutorial [here](https://devcenter.heroku.com/articles/deploying-a-parse-server-to-heroku#create-an-app)!  Submodule located at [cashdash-parse](https://github.com/kevinzhang96/cashdash-parse).

# APIs and SDKs
- iOS
	- Alamofire (networking)
	- SwiftyJSON (data processing)
	- Parse, ParseUI, ParseFacebookUtilsV4 (Parse integration)
- Backend (Heroku)
	- Heroku-CLI
	- Parse
	- MongoDB

# Parse Access
Instructions mostly online [here](https://github.com/ParsePlatform/parse-server).  Run `npm install -g parse-server mongodb-runner` to install required binaries, then `cd` into the server directory and do `mongodb-runner start` and `parse-server --appId APP_ID --masterKey MASTER_KEY`.

Integration with iOS through the migrated Parse server can be found [here](https://www.appcoda.com/parse-server-installation/).
