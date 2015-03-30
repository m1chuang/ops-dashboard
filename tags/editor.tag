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
        height: 29em;
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
      #code_btn{
        top:-1.7em;
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
    <a id="api_btn" onclick={show_api}>API</a>
    <div id="editor" show={(tab==1)}>{code}{o}</div>
    <div id="apipanel" show={(tab==2)}>
      <qbcontrol params={ data.data_process } if={true}></qbcontrol>
    </div>
    <a id="drag">drag</a>
    <a id="close_btn"onclick={close}>x</a>
    <a id="save_btn"onclick={save}>save</a>
  </div>

  <script>

  var self = this;
  self.show_editor=false;
  self.tab=1;
  self.editor="";
  self.data={};


  close(e){
    self.show_editor=false;
  }
  show_code(e){
    self.tab=1;
  }
  show_api(e){
    self.tab=2;
  }

  self.on('update, mount',function(){
    console.log('editor mounting');
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/javascript");
    editor.container.style.fontFamily = "monospace"
    self.editor=editor;
    $('#editor_panel').drags({handle:"#drag"});
  });

  save(e){
    rc.trigger("editor:save",{data:self.data, code:self.editor.getValue()});
  }

  rc.on("editor:show",function(params){
    self.data = params.item;
    self.editor.setValue(params.item.data_process.success);
    self.show_editor=true;
    self.update();
  });
  </script>

</editor>

<qbcontrol>
  <style>
    textarea{
      width:90%;
    }
    f {
      width: 100%;
      display: inline-block;
      margin-left: 10px;
    }
    #api_result{
      background:white;
    }
  </style>
  <div id="api_calll">
    {url}
  </div>
  <form>
    <label for="new_block_h">months
      <textarea name="months">{String(data.month || "")}</textarea>
    </label>
    <label for="new_block_h">query
      <textarea name="query">{String(data.field_raw || "")}</textarea>
    </label>
    <label for="new_block_h">clist
      <textarea name="clist">{String(data.extra || "")}</textarea>
    </label>
    <label for="new_block_h">slist
      <textarea name="slist">{String(data.slist || "")}</textarea>
    </label>
  </form>
  <a id="run" onclick={run}>Test</a>
  <div id="api_result"></div>
  <script>
  var self = this;
  this.data = opts.params;

  toggle_result(e){

  }

  run(e){
    rc.trigger("api:qb:query:incidents",{
      field_raw: this.query.value,
      extra: this.clist.value + this.slist.value,
      result_only:function(data){
        console.log('success on result_only callback');
        $('#api_result')[0].innerHTML = $(data).find('records')[0].innerHTML;
        $( "f" ).has( "f" ).addClass( "expandable" );
      }


    });
  }

  this.on('mount',function(){

  });
  this.on('update',function(){
    
    self.data=opts.params;
  })
  </script>
</qbcontrol>
