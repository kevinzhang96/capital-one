Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.define('sos', function(req, res) {
  console.log("TEST1");
  
  Parse.Push.send({
    channels: ["global"],
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

  Parse.Push.send({
    channels: ["global"]
    data: {
      alert: "awrogianwrogianwrgioawrng"
    }
  }, { success: function() {
      console.log("#### PUSH OK");
  }, error: function(error) {
      console.log("#### PUSH ERROR" + error.message);
  }, useMasterKey: true});

  response.success('success');
});
