<editor>
  <style type="text/css" media="screen">
      editor{
        z-index: 2;
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
      }
      #editor {
        position: absolute;
        height:100%;
        width: 100%;
      }
      #editor_panel{

        top: 0;
        right: 0;
        bottom: 0;
        left: 0;

        background:white;
        border:1px solid black;
        top:20%;
        height:60%;
        width:60%;
        font-family:monospace !important;
        width: 83em;
        height: 44em;
      }
      #editor_panel a{
        position:absolute;
        background: white;
        border: 1px solid black;
        cursor: pointer;
        color: red;
        padding:5px;
        font-size: 2em;
      }
      #close_btn, #save_btn{
        right: -1.3em;
        top:0;
      }

      #save_btn{
        top:2em;
        right: -3.1em;
      }
      div#apipanel {
        width: 100%;
        height: 100%;
      }
      #code_btn, #run_btn{
        top:-1.7em;
      }
      #run_btn{
        left:18em;
      }
      #api_btn{
        top:-1.7em;
        left:14em;
      }
      #drag{
        top:-1.7em;
        right:0;
      }
      div#apipanel label {
        width: 100%;
        display: inline-block;
      }
      #run, #show_result{
        position: relative !important;
        display: inline-block;
      }
  </style>

  <div id="editor_panel" show={show_editor} hide={!show_editor}>
    <a id="code_btn" onclick={show_code}>Data Processing</a>
    <a id="run_btn" onclick={run_processing}>run</a>
    <a id="api_btn" onclick={show_api}>API</a>
    <div name="processing" id="editor" show={(tab==1)} onkeyup={update_changes}></div>
    <div id="apipanel" show={(tab==2)}>
      <api name="api" params={ data.data_process } show={(type==0 || type==99)} ></api>
      <qbcontrol params={ data.data_process } show={(type==1 || type==99)} ></qbcontrol>
    </div>
    <div name="preview" show={(tab==3)}></div>
    <a id="drag">drag</a>
    <a id="close_btn" onclick={close}>x</a>
    <a id="save_btn" onclick={save}>save</a>
  </div>

  <script>

  var self = this;
  self.show_editor=false;
  self.tab=1;
  self.editor_processing=ace.edit(this.processing);;
  self.editor_processing.setTheme("ace/theme/monokai");
  self.editor_processing.getSession().setMode("ace/mode/javascript");
  self.editor_processing.container.style.fontFamily = "monospace"
  $('#editor_panel').drags({handle:"#drag"});
  self.data={};
  self.type = 99;
  self.content_html = ""
  close(e){
    self.show_editor=false;
  }
  show_code(e){
    self.tab=1;
  }
  show_api(e){
    self.tab=2;
  }

  update_changes(e){
    if(self.data.data_process) self.data.data_process.success = self.editor_processing.getValue();
  }

  save(e){
    rc.trigger("editor:save",{data:self.data, code:self.editor_processing.getValue()});
    console.log(this.data);
  }

  run_processing(e){
    console.log(self.data.data_process)
    self.tab=3;
    rc.trigger("api:general",{
      method: self.data.data_process.method,
      query:  self.data.data_process.query,
      before_send:  self.data.data_process.before_send,
      domain:       self.data.data_process.domain,
      success: self.data.data_process.success,
      next: function(table,id){
        $(self.preview)[0].innerHTML=create_table(table);
        self.update();
        console.log($(self.preview)[0].innerHTML);
      }
    });

  }

  self.on('update, mount',function(){
    console.log('editor mounting');
  });

  rc.on("editor:show",function(params){
    console.log("params.item");
    self.data = params.item;
    self.type = params.item.type;
    console.log(params.item.data_process);
    if(self.editor_processing) self.editor_processing.setValue(params.item.data_process.success);
    self.show_editor=true;
    self.update();
  });
  </script>

</editor>









<api>
  <style>
    form{
      padding:10px;
      font-size:1.2em;
    }
    textarea{
      width:100%;
    }
    label{
      margin-top:5px;
      margin-bottom:5px;
    }
    #damain{

    }
    f {
      width: 100%;
      display: inline-block;
      margin-left: 10px;
    }
    #api_result{
      background:white;
    }
    #editor_panel a{
      position:absolute;
      background: white;
      border: 1px solid black;
      cursor: pointer;
      color: red;
      padding:5px;
      font-size: 2em;
    }
    #beforesend, #payload{
      height:5em;
    }
    #domain{
      width:90% !important;
    }
    #method{
      width:9% !important;
    }
    #api_result1{
      width:90%;
      min-height:18em;
      height:58em;
    }
  </style>

  <form onload={update_url} >
    <label id="method"><b>HTTP method</b>
      <textarea name="method" onkeyup={update_url}>{data.method}</textarea>
    </label>
    <label id="domain"><b>Domain</b>
      <textarea name="domain" onkeyup={update_url}>{data.domain}</textarea>
    </label>
    <label><b>Payload</b>
      <div name="payload" id="payload" onkeyup={update_url}></div>
    </label>
    <label><b>BeforeSend (Headers, MIME, etc)</b>
      <div name="beforesend" id="beforesend" onkeyup={update_url}></div>
    </label>
    <label><b>RAW URL</b>
    <p id="raw_url" name="raw_url">{ data.method+":"+ data.domain }</p>
    </label>
    <p id="unsaved_api" show={(!saved)} hide={(saved)}>unsaved changes: API {saved}</p>
    <a id="run" onclick={run}>Test</a>
  </api>

  <div name="api_result1" id="api_result1"></div>
  <script>
  var self = this;
  var original =  jQuery.extend({}, opts.params);
  this.data = opts.params;


  this.editor_result = ace.edit(this.api_result1);
  this.editor_beforesend = ace.edit(this.beforesend);
  //editor_beforesend.setTheme("ace/theme/monokai");
  this.editor_beforesend.getSession().setMode("ace/mode/javascript");
  this.editor_beforesend.container.style.fontFamily = "monospace";
  this.editor_data = ace.edit(this.payload);
  //editor_beforesend.setTheme("ace/theme/monokai");
  this.editor_data.container.style.fontFamily = "monospace";
  self.saved = true;

  update_url(e){
    this.data.domain = this.domain.value || "";
    this.data.method = this.method.value || "";
    this.data.query = this.editor_data.getValue() || "";
    this.data.before_send = this.editor_beforesend.getValue() || "";
    for( key in original){
      if(!original[key]){
      }else if(original[key]!=this.data[key]){
        console.log("unsaved changes");
        console.log(original[key]);
        console.log(this.data[key]);
        self.saved = false;
      }
    }
    this.update();
  }

  run(e){
    console.log(this.data);
    rc.trigger("api:general",{
      method: this.method.value,
      query:  this.editor_data.getValue(),
      before_send:  this.editor_beforesend.getValue(),
      domain:       this.domain.value,
      result_only:function(data){
        console.log('success on result_only callback');
        console.log(JSON.stringify(data));
        self.editor_result.setValue(data);
      }
    });
  }

  this.on('mount',function(){
    console.log('mounting api panel');
  });
  this.on('update',function(){
    console.log('update api panel');
    console.log(original);
    console.log(self.data);
    console.log(self.saved);
    if(self.editor_beforesend && self.data)self.editor_beforesend.setValue(self.data.before_send || "var beforesend = function(xhr){\n};");
    if(self.data && self.data.query)self.editor_data.setValue(self.data.query || "");
    original =  self.saved? jQuery.extend({}, opts.params):original;
    self.data=opts.params;
  });
  rc.on("editor:save",function(params){
    console.log('saving api panel editor..');
    self.saved = true;
    original =  self.saved? jQuery.extend({}, self.data):original;
  });
  rc.on("editor:show",function(params){
  });
  </script>
</api>




















<qbcontrol>
  <style>
    form{
      padding:10px;
      font-size:1.2em;
    }
    textarea{
      width:100%;
    }
    label{
      margin-top:5px;
      margin-bottom:5px;
    }
    #damain{

    }
    f {
      width: 100%;
      display: inline-block;
      margin-left: 10px;
    }
    #api_result{
      background:white;
    }
    #editor_panel a{
      position:absolute;
      background: white;
      border: 1px solid black;
      cursor: pointer;
      color: red;
      padding:5px;
      font-size: 2em;
    }
  </style>
  <form>
    <label><b>Domain</b>
      <p id="domain">{data.domain}</p>
    </label>

    <label><b>Api type</b>
      <textarea name="api_type" onkeyup={update_url} >{data.api_type}</textarea>
    </label>
    <label><b>DB id</b>
      <textarea name="db_id" onkeyup={update_url} >{data.db_id}</textarea>
    </label>
    <label><b>App token</b>
      <textarea name="app_token" onkeyup={update_url} >{data.app_token}</textarea>
    </label>
    <label><b>Auth ticket</b>
      <textarea name="auth_ticket" onkeyup={update_url} >{data.auth_ticket}</textarea>
    </label>
    <label><b>Query</b>
      <textarea name="query" onkeyup={update_url} >{data.query}</textarea>
    </label>
    <label><b>RAW URL</b>
      <p id="raw_url" name="raw_url">{ data.domain + "/db/" + data.db_id + "?a="+data.api_type+"&apptoken="+data.app_token}<br>{'&ticket='+data.auth_ticket+"&"+ data.query}</p>
    </label>

    <p id="unsaved_api" hide={!saved}>unsaved changes: API</p>
    <a id="run" onclick={run}>Test</a>
  </form>

  <div id="api_result"></div>
  <script>
  var self = this;
  var original =  jQuery.extend({}, opts.params);
  this.data = opts.params;
  var saved = true;

  //this.url = this.data.domain +'/'+ this.data.app_id || ''; //+ "?a="+this.data.api_type+"&apptoken="+this.data.app_token+'&ticket='+this.data.auth_ticket+"&"+ this.data.query;

  update_url(e){
    this.data.api_type = this.api_type.value;
    this.data.db_id = this.db_id.value;
    this.data.app_token = this.app_token.value;
    this.data.auth_ticket = this.auth_ticket.value;
    this.data.query = this.query.value;
    console.log('original');
    console.log(original);
    console.log(this.data);
    saved = true;
    for( key in original){
      if(original[key]!=this.data[key]){
        console.log("unsaved changes");
        saved = false;
      }
    }
    this.update();
  }

  run(e){
    rc.trigger("api:qb",{
      data: this.data,
      result_only:function(data){
        console.log('success on result_only callback');
        $('#api_result')[0].innerHTML = $(data).find('records')[0].innerHTML;
        $( "f" ).has( "f" ).addClass( "expandable" );
      }
    });
  }

  this.on('mount',function(){
    original =  jQuery.extend({}, opts.params);
  });
  this.on('update',function(){
    console.log('update api panel')
    console.log(saved);
    original =  saved? jQuery.extend({}, opts.params):original;
    self.data=opts.params;
  });
  rc.on("editor:show",function(params){
    console.log('qc params.item');
  })
  </script>
</qbcontrol>

<raw>
  <span></span>
  this.root.innerHTML = opts.content
</raw>
