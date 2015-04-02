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
      rc.trigger("block:change", self.blocks.toArray());
    } else {
      rc.trigger("api:qb:query:incidents", {
        field_raw: item.field_raw,
        extra: item.extra,
        success: success,
        block_id: item.id,
        next: function(incident_table, block_id) {
          console.log(
            "SUCCESS on running eval block data processing");
          window.localStorage.setItem("block_data_" + block_id,
            JSON.stringify(
              incident_table));
          var block_data = incident_table;
          item.content_html = eval(item.content_raw);
          item.block_data = incident_table;
        }
      });
    }
  });

  self.on('block:add', function(item) {
    console.log('block:add');
    self.blocks.push(item);
    rc.trigger("block:change", self.blocks.toArray());
  })

  self.on('block:delete', function(item) {
    console.log('block:delete');

    console.log(self.blocks);
    self.blocks = self.blocks.reject(function(block) {
      console.log('rejecting')
      console.log(block.id);
      console.log(item.id);
      console.log(block.id == item.id);
      return block.id == item.id
    });
    console.log(self.blocks);
    rc.trigger('block:change', self.blocks.toArray());
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
    console.log(self.blocks);
    //console.log(JSON.stringify(self.blocks.toJSON()));

    rc.trigger('block:change', self.blocks.toArray());
  });

  self.on('dashboard:save', function() {
    //console.log(self.blocks);
    console.log(JSON.stringify(self.blocks.toJSON()));
    console.log(self.blocks.toArray());
    //rc.trigger('block:change', self.blocks.toArray());
    $.ajax({
      url: 'https://api.github.com/gists/80cffc4fb8dfab253d6b',
      type: 'PATCH',
      beforeSend: function(xhr) {
        xhr.setRequestHeader("Authorization",
          "token 625321acea99ec66170597ac3a029cab9199396e");
      },
      data: JSON.stringify({
        "description": "updated gist via ajax",
        "public": true,
        "files": {
          "dashboard_data_processing": {
            "content": JSON.stringify({
              data: {},
              blocks: self.blocks.toArray()
            })
          }
        }
      })
    }).done(function(response) {
      console.log(response);
    });
  });


  self.on('api:general', function(params) {
    console.log('api:general');
    console.log(params);
    var methods = ['GET', 'POST', 'PUT'];
    eval(params.before_send);
    $.ajax({
      type: params.method,
      url: params.domain,
      data: params.query,
      beforeSend: beforesend,
      success: function(data) {
        console.log("SUCCESS on general api");
        if (params.success && params.next && !params.result_only) {
          var success;
          eval(params.success);
          success(data, params.block_id, params.next);
        } else if (params.result_only) {
          params.result_only(data);
        }
      }
    });
  })
}
