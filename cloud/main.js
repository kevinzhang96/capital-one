Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.define('sos', function(req, res) {
  var query = new Parse.Query(Parse.Installation);

  Parse.Push.send({
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
    }
  });
});