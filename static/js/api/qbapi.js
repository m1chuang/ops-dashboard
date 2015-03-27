var qbapi = function(params) {
	this.domain = params.domain;
	this.dbId = params.dbId;
	this.appToken = params.appToken;
	this.auth_ticket = params.auth_ticket;
	this.url = 'https://' + params.domain + '/db/' + params.dbId;
	this.get = function(url, success) {
		console.log(url);
		$.ajax({
			type: "GET",
			url: "https://still-castle-8872.herokuapp.com/?url=" + url,
			dataType: "xml",
			success: success
		});
	}; //eof get
	if (!this.auth_ticket) {
		this.get("https://" + params.domain +
			"/db/main?a=API_Authenticate&username=mchuang&password=Nesh6502&hours=48", (
				function(data) {
					console.log(data)
					this.auth_ticket = $(data).find('ticket')[0].innerHTML;
				}).bind(this));
	}
};
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
	domain: "intuitcorp.quickbase.com",
	dbId: "54xa5xi4",
	appToken: "ek8d4acxepjmubgkjiypb6nkh9q",
	auth_ticket: "7_bjtqrupxz_b2fvy4_k_a_cjxct7rbgqub2fdv3ci9u678fpncyjkq743zry6cbhiz2y7cry6s2n"
})

var incident_table = {};
//get incident from the four services and calculate number of incidents and total incident duration
subscribe("api:qb:query:incidents", function(params) {
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
			/*
						$(data).find('record').each(
							function(i, val) {
								var service_name = $(val).find('#10')[0].innerHTML.replace(/ /g,
									'-');
								var incident_duration = parseInt($(val).find('#8')[0].innerHTML
									.replace(
										/ /g, '-'), 10);

								arry.push({
									service: service_name,
									incident_duration: incident_duration
								});

								if (service_name in incidents) {
									incidents[service_name]['count'] += 1;
									incidents[service_name]['total_duration'] +=
										incident_duration;
									incidents[service_name]['uptime'] = (1 - incidents[
										service_name]['total_duration'] / (3 * 30 * 24 * 60)).toPrecision(
										4);

								} else {
									incidents[service_name] = {
										count: 1,
										total_duration: incident_duration,
										uptime: (1 - incident_duration / (3 * 30 * 24 * 60)).toPrecision(
											4)
									}
								};

							});
						incident_table.data = incidents;
						incident_table.names = ['service', '# incidents', 'total_duration',
							'uptime'
						];
			    */
			params.success(data, params.block_id, function(incident_table, block_id) {
				console.log("SUCCESS on running eval block data processing");
				window.localStorage.setItem("block_data_" + block_id, JSON.stringify(
					incident_table));
				publish("block:render", [{
					block_id: block_id
				}]);

			});

		}
	});
})
