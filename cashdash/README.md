# Cash Dash
Parse setup tutorial [here](https://devcenter.heroku.com/articles/deploying-a-parse-server-to-heroku#create-an-app)!  Submodule located at [cashdash-parse](https://github.com/kevinzhang96/cashdash-parse).

# APIs, SDKs and Libraries
- iOS
	- CoreLocation
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

# Database
Access the database at https://www.mlab.com/databases/heroku_trnhb0fs/.  You will need a login; contact a team member for information.  The Parse dashboard appears to be bugged at the moment; data does not show up correctly.

# Heroku
Dashboard available [here](https://dashboard-preview.heroku.com/apps/cap-cashdash/resources).  App is deployed at https://cap-cashdash.herokuapp.com; endpoints are available through /parse, at /push and /test.  API keys are needed (client key, master key, and REST API key).  


