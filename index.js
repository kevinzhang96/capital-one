// Example express application adding the parse-server module to expose Parse
// compatible API routes.

var express = require('express');
var ParseServer = require('parse-server').ParseServer;
var path = require('path');

var databaseUri = process.env.DATABASE_URI || process.env.MONGODB_URI;

if (!databaseUri) {
  console.log('DATABASE_URI not specified, falling back to localhost.');
}

var api = new ParseServer({
  databaseURI: databaseUri || 'mongodb://heroku_trnhb0fs:3upppvdr8le1oj71fdgnurg388@ds033484.mlab.com:33484/heroku_trnhb0fs',
  cloud: process.env.CLOUD_CODE_MAIN || __dirname + '/cloud/main.js',
  appId: process.env.APP_ID || 'KeSeybm7QVaTSxFmYrQ2UEaCUJPSdyrWjeaZqHWq',
  masterKey: process.env.MASTER_KEY || 'TTbrjiJoG1omIocMkbZnIsxJw1bLHQciyZ9UkCO2', //Add your master key here. Keep it secret!
  serverURL: process.env.SERVER_URL || 'http://cap-cashdash.herokuapp.com/parse',  // Don't forget to change to https if needed
  liveQuery: {
    classNames: ["Posts", "Comments"] // List of classes to support for query subscriptions
  }
});
// Client-keys like the javascript key or the .NET key are not necessary with parse-server
// If you wish you require them, you can set them as options in the initialization above:
// javascriptKey, restAPIKey, dotNetKey, clientKey

var app = express();

// Serve static assets from the /public folder
app.use('/public', express.static(path.join(__dirname, '/public')));

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('I dream of being a website.  Please star the parse-server repo on GitHub!');
});

app.get('/test', function(req, res) {
  res.status(200).send('test');
});

app.get('/hello', function(req, res) {
  Parse.Cloud.run('hello');
  res.status(200).send('hello');
});

app.get('/sos', function(req, res) {
  Parse.Cloud.run('sos');
  res.status(200).send("sent notifications");
});

var port = process.env.PORT || 1337;
var httpServer = require('http').createServer(app);
httpServer.listen(port, function() {
    console.log('parse-server-example running on port ' + port + '.');
});

// This will enable the Live Query real-time server
ParseServer.createLiveQueryServer(httpServer);
