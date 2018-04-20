// Example express application adding the parse-server module to expose Parse
// compatible API routes.
var express = require('express');
var ParseServer = require('parse-server').ParseServer;

var databaseUri = process.env.DATABASE_URI || process.env.MONGOLAB_URI

if (!databaseUri) {
  console.log('DATABASE_URI not specified, falling back to localhost.');
}

var pushConfig = {};

if (process.env.GCM_SENDER_ID && process.env.GCM_API_KEY) {
    pushConfig['android'] = { senderId: process.env.GCM_SENDER_ID || '',
                              apiKey: process.env.GCM_API_KEY || ''};
}

if (process.env.APNS_ENABLE) {
    pushConfig['ios'] = [
        {
            pfx: 'certificate.p12', // P12 file only
            bundleId: 'theanimasian.CashDash',  // change to match bundleId
            production: false // dev certificate
        }
    ]
}


var filesAdapter = null;  // enable Gridstore to be the default
if (process.env.S3_ENABLE) {
    var S3Adapter = require('parse-server').S3Adapter;

    filesAdapter = new S3Adapter(
        process.env.AWS_ACCESS_KEY,
        process.env.AWS_SECRET_ACCESS_KEY,
        {bucket: process.env.AWS_BUCKET_NAME, bucketPrefix: "", directAccess: true}
    );
}

var api = new ParseServer({
  databaseURI: databaseUri || 'mongodb://heroku_trnhb0fs:3upppvdr8le1oj71fdgnurg388@ds033484.mlab.com:33484/heroku_trnhb0fs',
  cloud: process.env.CLOUD_CODE_MAIN || __dirname + '/cloud/main.js',
  appId: process.env.APP_ID || 'KeSeybm7QVaTSxFmYrQ2UEaCUJPSdyrWjeaZqHWq',
  masterKey: process.env.MASTER_KEY || 'TTbrjiJoG1omIocMkbZnIsxJw1bLHQciyZ9UkCO2', //Add your master key here. Keep it secret!
  push: pushConfig,
  filesAdapter: filesAdapter,
  serverURL: process.env.SERVER_URL || 'http://cap-cashdash.herokuapp.com/parse'  // needed for Parse Cloud and push notifications
});
// Client-keys like the javascript key or the .NET key are not necessary with parse-server
// If you wish you require them, you can set them as options in the initialization above:
// javascriptKey, restAPIKey, dotNetKey, clientKey

var app = express();

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('I dream of being a web site.');
});

app.get('/test', function(req, res) {
  res.status(200).send('test');
});

app.get('/push', function(req, res) {
  Parse.Cloud.run('iosPushTest');
  res.status(200).send('sent push notification');
});

var port = process.env.PORT || 1337;
app.listen(port, function() {
    console.log('parse-server-example running on port ' + port + '.');
});
