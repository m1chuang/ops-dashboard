/*var gistapi = function(params) {
	this.get = function(url, success) {
    console.log(success);
    console.log(url);
		$.ajax({
			type: "GET",
			url: "https://api.github.com/gists/"+url,
			success: success });
       }; //eof get
};

gistapi.prototype.fetch=function(gist_id){
  this.get(gist_id, function(data,e){
    return data
  });
};

var gist = new gistapi({});
var y,h;
y=gist.fetch('80cffc4fb8dfab253d6b');
*/


$.ajax({
  type: "GET",
  url: "https://api.github.com/gists/" + '80cffc4fb8dfab253d6b' +
    '?access_token=625321acea99ec66170597ac3a029cab9199396e',
  success: function(data, err) {
    var dashboard_data = JSON.parse(data.files.dashboard_data_processing.content);
    setTimeout(function() {
      for (key in dashboard_data.blocks) {
        rc.trigger('block:build', dashboard_data.blocks[key]);
      }
    }, 100);


    setTimeout(function() {
      rc.trigger('block:all');
    }, 600);
    console.log(err)
  }
});
