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
var dashboard_data,items;

$.ajax({
  type: "GET",
  url: "https://api.github.com/gists/"+'80cffc4fb8dfab253d6b',
  success: function(data, err){
    dashboard_data=JSON.parse(data.files.dashboard_data_processing.content);
    items=[];
    for(key in dashboard_data.blocks){
      eval(dashboard_data.blocks[key].data_proccess.success);//var success = func
      items.push(dashboard_data.blocks[key]);
      publish("api:qb:query:incidents",[{
        field_raw : dashboard_data.blocks[key].field_raw,
        extra     : dashboard_data.blocks[key].extra,
        success   : success,
        block_id   : dashboard_data.blocks[key].id        
      }]);
      console.log("dashboard_data.blocks[key].content_html")
      console.log(success)
      console.log(dashboard_data.blocks[key].content_html)
      console.log(dashboard_data.blocks[key].content_raw)
    }
    console.log(items)
    riot.mount('grid',{size:4, items:items});
    console.log(err)
  }
  });
