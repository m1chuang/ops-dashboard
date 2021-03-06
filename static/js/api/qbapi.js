var qbapi = function(params) {
	this.domain = params.domain;
	this.dbId = params.dbId;
	this.appToken = params.appToken;
	this.auth_ticket = params.auth_ticket;
	this.url = params.domain + '/db/' + params.dbId;
	this.get = function(url, success) {
		console.log(url);
		$.ajax({
			type: "GET",
			url: "https://still-castle-8872.herokuapp.com/?url=" + url,
			dataType: "xml",
			success: success
		});
	}; //eof get
	if (false) {
		this.get(params.domain +
			"/db/main?a=API_Authenticate&username={0}&password={1}}&hours=48", (
				function(data) {
					console.log(data)
					this.auth_ticket = $(data).find('ticket')[0].innerHTML;
				}).bind(this));
	}
};
qbapi.prototype.renew_auth_ticket = function(next) {
	console.log("making renew auth_ticket api call")
	this.get(this.domain +
		"/db/main?a=API_Authenticate&username={0}}&password={1}}&hours=48", (
			function(data) {
				console.log(data)
				this.auth_ticket = $(data).find('ticket')[0].innerHTML;
				next($(data).find('ticket')[0].innerHTML);
			}).bind(this));
}
qbapi.prototype.query = function(params) {
	var fields = array(params.fields).map(function(val, i) {
		return "{'" + val.field + "'." + val.op + ".'" + val.value + "'}"
	}).join('AND');
	var ops = array(params.extra).map(function(val, i) {
		return val
	}).join('');
	this.get(this.url + '?a=API_DoQuery&apptoken=' + this.appToken + '&ticket=' +
		this.auth_ticket + '&query=' + params.field_raw + fields + ops +
		'&fmt=structured', params.success);
}

var aims = new qbapi({
	domain: "https://intuitcorp.quickbase.com",
	dbId: "54xa5xi4",
	appToken: "",
	auth_ticket: ""
})


var incident_table = {};
var qb = new qbapi({
	domain: "https://intuitcorp.quickbase.com",
	dbId: "54xa5xi4",
	appToken: "",
	auth_ticket: ""
});;
rc.on("api:qb", function(params) {
	console.log("api:qb");
	qb = new qbapi({
		domain: params.data.domain || "https://intuitcorp.quickbase.com",
		dbId: params.data.db_id || "54xa5xi4",
		appToken: params.data.app_token || "",
		auth_ticket: params.data.auth_ticket ||
			""
	});
	qb.query({
		field_raw: params.data.query ||
			"{'5'.IR.'last+3+mon'}AND{'126'.CT.'ICS'}AND({'10'.CT.'Registry'}OR{'10'.CT.'Messaging'}OR{'10'.CT.'API Portal'}OR{'10'.CT.'API Gateway'})&clist=126.5.10.8",
		success: function(data) {
			console.log("SUCCESS on qbapi");
			if (params.success && params.next && !params.result_only) {
				params.success(data, params.block_id, params.next);
			} else if (params.result_only) {
				params.result_only(data);
			}
		}
	})
});

//get incident from the four services and calculate number of incidents and total incident duration
rc.on("api:qb:query:incidents", function(params) {
	console.log("api:qb:query:incidents");

	aims.query({
		fields: [
			//{field:126,value:'ICS',op:'CT',logic:'AND'},
			//{field:10,value:'Portal',op:'CT'}
		],
		field_raw: params.field_raw ||
			"{'5'.IR.'last+3+mon'}AND{'126'.CT.'ICS'}AND({'10'.CT.'Registry'}OR{'10'.CT.'Messaging'}OR{'10'.CT.'API Portal'}OR{'10'.CT.'API Gateway'})",
		extra: params.extra || [
			"&clist=126.5.10.8"
		],
		success: function(data) {
			console.log("SUCCESS on qbapi");
			if (params.success && params.next && !params.result_only) {
				params.success(data, params.block_id, params.next);
			} else if (params.result_only) {
				params.result_only(data);
			}
		}
	});
})

rc.on("api:quickbase:renew_auth_ticket", function(next) {
	console.log("renewing auth ticket")
	qb.renew_auth_ticket(next);
});
