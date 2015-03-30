// gridStore definition.
// house application logic and state that relate to a specific domain.
function gridStore() {
	riot.observable(this) // Riot provides our event emitter.

	var self = this

	self.blocks = new array([]);

	// Event handlers / API.
	// This is where we would use AJAX calls to interface with the server.
	// Any number of views can emit actions/events without knowing the specifics of the back-end.
	// This store can easily be swapped for another, while the view components remain untouched.
	self.on('block:build', function(item) {
		console.log("Block:add");
		self.blocks.push(item);
		var success = function() {};
		eval(item.data_process.success); //var success = func
		if (Object.keys(item.data_process).length == 0) {
			rc.trigger("block:change", [item]);
		} else {
			rc.trigger("api:qb:query:incidents", {
				field_raw: item.field_raw,
				extra: item.extra,
				success: success,
				block_id: item.id,
				next: function(incident_table, block_id) {
					console.log("SUCCESS on running eval block data processing");
					window.localStorage.setItem("block_data_" + block_id, JSON.stringify(
						incident_table));
					var block_data = incident_table;
					item.content_html = eval(item.content_raw);
					item.block_data = incident_table;
					rc.trigger("block:change", [item]);
				}
			});
		}
	});

	self.on('block:add', function(item) {
		console.log('block:add');
		self.blocks.push(item);
		rc.trigger("block:change", [item]);
	})



	self.on('block:position:update', function(items) {
		console.log("block:positoin:update");
		items.forEach(function(item, i) {
			self.blocks.select({
				id: parseInt(item.id, 10)
			})[0].position = item.position;
		});
	});

	self.on('editor:save', function(params) {
		console.log('editor:save');
		console.log(params.data);
		console.log(params.code);
	})

	self.on('block:all', function() {
		//console.log(self.blocks);
		//console.log(JSON.stringify(self.blocks.toJSON()));
		rc.trigger('block:change', self.blocks.toArray());
	});
}
