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
      #close_btn, #save_btn, #apply_btn{
        right: -1.3em;
        top:0;
      }

      #save_btn{
        top:2em;
        right: -3.2em;
      }

      #apply_btn{
        top:5em;
        right: -3.9em;
      }
      div#apipanel {
        width: 100%;
        height: 100%;
      }
      #code_btn, #run_btn{
        top:-1.7em;
      }
      #run_btn{
        left: 22em;
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
      .editor_wrap .editor-toolbar a{
        position:relative !important;
      }
  </style>

  <div id="editor_panel" show={show_editor} hide={!show_editor}>
    <a id="code_btn" show={ (type!=5 || type==99) } onclick={show_code} >Data Processing</a>
    <a id="run_btn" show={ (type!=5 || type!=3 || type==99) } onclick={run_processing}>run</a>
    <a id="api_btn" onclick={show_api} hide={(type ==2)}>Data Source</a>
    <div class="editor_wrap">
      <div name="processing" id="editor" show={(tab==1 && type!=5)} onkeyup={update_changes}></div>
    </div>
    <div id="apipanel" show={(tab==2)}>
      <api name="api" params={ data.data_process } show={(type==0 || type==99)} ></api>
      <qbcontrol params={ data.data_process } show={(type==1 || type==99)} ></qbcontrol>
      <imagecontrol params={ data.data_process } show={(type==3 || type==99)}></imagecontrol>
      <listcontrol params={ data.data_process } show={(type==5 || type==99)}></listcontrol>
    </div>
    <div name="preview" id="{'preview'+String(data.id)}" show={(tab==3)}></div>
    <a id="drag">drag</a>
    <a id="close_btn" onclick={close}>x</a>
    <a id="save_btn" onclick={save}>save</a>
    <a id="apply_btn" onclick={apply_result}>apply</a>
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


  self.editor_markdown;
  self.data={};
  self.type = 99;
  self.content_html = "";

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
    var code;
    if(self.type==5){    
    }else{
      code = self.editor_processing.getValue();
    }
    rc.trigger("editor:save",{data:self.data, code:code});
    console.log(this.data);
  }

  apply_result(e){
    if(self.type==3){
      console.log("apply image...");
      var html = "<div style='height: 90%; background-image: url("+self.data.data_process.image_src+"); background-size: cover; background-position: 50% 50%; background-repeat: no-repeat;'></div>"
      self.data.data_process.content_html = html;
      self.data.content_html = html;
      $('li#'+self.data.id+" raw")[0].innerHTML=html;
      self.update();
    }else if(self.type == 2){
      eval(self.data.data_process.success);
      document.getElementById('content'+String(self.data.id)).appendChild(success());
    }else{
      general_api(function(html){
        $('li#'+self.data.id+" raw")[0].innerHTML=html;
        self.data.data_process.content_html = html;
        self.update();
        console.log($(self.preview)[0].innerHTML);
      });
    }
  }
  run_processing(e){
    console.log('run processing...')
    self.tab=3;
    if(self.type == 2){
      var success;
      eval(self.data.data_process.success);
      document.getElementById('preview'+String(self.data.id)).appendChild(success());
    }else{
      general_api(function(table,id){
          $(self.preview)[0].innerHTML=table;
          self.update();
          console.log($(self.preview)[0].innerHTML);
        });
    }
  };
  function general_api(next){
    rc.trigger("api:general",{
      method: self.data.data_process.method,
      query:  self.data.data_process.query,
      before_send:  self.data.data_process.before_send,
      domain:       self.data.data_process.domain,
      success: self.data.data_process.success,
      next: next
    });
  };

  self.on('mount',function(){
    $('#editor_panel').drags({handle:"#drag"});
  });

  rc.on("editor:show",function(params){
    self.data = params.item;
    self.type = params.item.type;
    if(self.editor_processing) self.editor_processing.setValue(params.item.data_process.success);
    self.show_editor=true;
    if(self.type==5){
      self.tab=2;
    }
    self.update();
  });
  </script>

</editor>








<!-- GENERIC API BLOCK -->

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
    console.log("running");
    rc.trigger("api:general",{
      method: this.method.value,
      query:  this.editor_data.getValue(),
      before_send:  this.editor_beforesend.getValue(),
      domain:       this.domain.value,
      result_only:function(data){
        console.log('success on result_only callback');
        console.log(JSON.stringify(data));
        self.editor_result.setValue(JSON.stringify(data));
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
    original =  self.saved? jQuery.extend({}, opts.params):original;
    self.data=opts.params;
  });
  rc.on("editor:save",function(params){
    console.log('saving api panel editor..');
    self.saved = true;
    original =  self.saved? jQuery.extend({}, self.data):original;
  });
  rc.on("editor:show",function(params){
    if(self.editor_beforesend && self.data)self.editor_beforesend.setValue(self.data.before_send || "var beforesend = function(xhr){\n};");
    if(self.data && self.data.query)self.editor_data.setValue(self.data.query || "");
  });
  </script>
</api>


















<!-- QUICK BASE BLOCK -->

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
    #auth_ticket a{
      width: 9%;
      margin-right: 1%;
      position: relative !important;
      display: inline-block;
      line-height: 14px;

    }
    #auth_ticket textarea{
      width: 84%;
      position: relative;
      display: inline-block;
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
    <label id="auth_ticket"><b>Auth ticket</b>
    <div>
      <a onclick={renew}>renew</a>
      <textarea name="auth_ticket" onkeyup={update_url} >{data.auth_ticket}</textarea>
    </div>
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
  renew(e){
    console.log("renew clicked")
    rc.trigger("api:quickbase:renew_auth_ticket",function(ticket){
      self.data.auth_ticket = ticket;
      console.log(ticket);
      self.update();
    });
  }
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
        $('#api_result')[0].innerHTML = $(data).find('records')[0]? $(data).find('records')[0].innerHTML:$(data).find('errdetail')[0].innerHTML;
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




<!-- IMAGE BLOCK -->

<imagecontrol>
  <style>

  </style>
  <form>

    <label><b>src</b>
      <textarea name="image_src" onkeyup={update_url} >{data.image_src}</textarea>
    </label>

    <p id="unsaved_api" hide={!saved}>unsaved changes: SRC</p>
    <a id="run" onclick={run}>Test</a>
  </form>

  <div name="image_result"></div>
  <script>
  var self = this;
  var original =  jQuery.extend({}, opts.params);
  this.data = opts.params;
  var saved = true;

  //this.url = this.data.domain +'/'+ this.data.app_id || ''; //+ "?a="+this.data.api_type+"&apptoken="+this.data.app_token+'&ticket='+this.data.auth_ticket+"&"+ this.data.query;

  update_url(e){
    this.data.image_src = this.image_src.value;
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
    self.data.content_html = "<img src='"+self.data.image_src+"'>";
    $(this.image_result)[0].innerHTML="<img src='"+self.data.image_src+"'>";
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
</imagecontrol>


<!-- LIST BLOCK -->

<listcontrol>
  <style>
  #add{
    position:relative;
    position: relative;
    top: 0.5em;
    left: 0.5em;
  }
  #list{
    position: relative;
    top: 5em;
    left: 1em;
    width: 100%;
  }
  .item{
    margin-top: 0.5em;
    line-height: 1.5em;
  }
  listcontrol .item:hover{
    background:wheat;
  }
  listcontrol .item:hover button{
    display:block;
  }
  .item button{
    display:none;
    position: absolute;
    height: inherit;
    width: 2em;
    font-size: 1.5em;
    margin: 0;
  }
  .content{
    width: 70%;
    height: initial !important;
    display: inline-block;
    margin-left: 5em;
    text-align: left;
  }
  #numbering{
    position: absolute;
    margin-left: 3.5em;
  }
  </style>
  <a id="add" onclick={add_list_item}>+</a>
  <div id="list" name="list">
    <div class="item" each={item, i in data.list}>
      <button onclick={parent.delete_list_item}>-</button>
      <span id="numbering">{i+1}. </span>
      <raw class="content" contentEditable="true" onkeyup={parent.update_content} content="{item.content}"/>

    </div>
  </div>
  <p id="unsaved_api" hide={!saved}>unsaved changes: list</p>
  <script>
  var self = this;
  var original =  jQuery.extend({}, opts.params);
  this.data = opts.params;
  var saved = true;

  add_list_item(e){
    console.log("adding list item");
    self.data.list.push({content:"some content"});
    self.update();
  }

  delete_list_item(e){
   self.data.list.splice(e.item.i, 1);
  }

  update_content(e){
    console.log("updating.. list item");
    self.data.list[e.item.i].content=e.currentTarget.innerHTML;
    console.log(e.currentTarget.innerHTML);
    console.log(e.currentTarget.text);
    console.log(e.currentTarget.innerText);
  }
  this.on('mount',function(){
    original =  jQuery.extend({}, opts.params);

  });

  this.on('update',function(){
    console.log('update api panel')
    original =  saved? jQuery.extend({}, opts.params):original;
    self.data=opts.params;
    if(self.data) self.data.content_html = this.list.innerHTML;
    console.log(this.list.innerHTML);
    console.log(self.data)

  });

  rc.on("editor:show",function(params){
    console.log('qc params.item');
  })
  </script>
</listcontrol>



<raw>
  <span></span>
  this.root.innerHTML = opts.content
</raw>
