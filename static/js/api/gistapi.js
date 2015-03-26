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
var dashboard_data;
$.ajax({
  type: "GET",
  url: "https://api.github.com/gists/"+'80cffc4fb8dfab253d6b',
  success: function(data, err){
    dashboard_data=data.files.dashboard_data_processing.content;
    console.log(err)
  }
  });
