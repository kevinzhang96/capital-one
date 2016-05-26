Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.define('sos', function(req, res) {
  console.log("TEST1");
  
  var query = new Parse.Query(Parse.Installation);

  console.log("TEST2");
  Parse.Push.send({
    channels: ["global"],
    where: query, // Set our Installation query
    data: {
      alert: "Broadcast to everyone"
    }
  }, {
    success: function() {
      // Push was successful
      console.log("success");
    },
    error: function(error) {
      console.log("error")
      console.log(error);
    },
    useMasterKey: true
  });

  console.log("TEST3");

  res.success("notification sent");
  
  console.log("TEST4");
});

// iOS push testing
Parse.Cloud.define("iosPushTest", function(request, response) {

  // request has 2 parameters: params passed by the client and the authorized user                                                                                                                               
  var params = request.params;
  var user = request.user;

  // Our "Message" class has a "text" key with the body of the message itself                                                                                                                                    
  var messageText = params.text;

  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo('deviceType', 'ios'); // targeting iOS devices only                                                                                                                                          

  Parse.Push.send({
    where: pushQuery, // Set our Installation query                                                                                                                                                              
    data: {
      alert: "Message: " + messageText
    }
  }, { success: function() {
      console.log("#### PUSH OK");
  }, error: function(error) {
      console.log("#### PUSH ERROR" + error.message);
  }, useMasterKey: true});

  response.success('success');
});
