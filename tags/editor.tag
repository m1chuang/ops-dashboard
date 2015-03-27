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


        top:20%;
        height:60%;
        width:60%;
        font-family:monospace !important;
        width: 83em;
        height: 29em;
      }
      #close_btn, #save_btn{
        position:absolute;
        right: -1em;
        font-size: 2em;
        color: red;
        background: white;
        border: 1px solid black;
        cursor: pointer;
      }
      #save_btn{
        top:2em;
        right:-3em;
      }
  </style>

  <div id="editor_panel" show={show_editor} hide={!show_editor}>
    <div id="editor">{code}{o}</div>
    <a id="close_btn"onclick={close}>x</a>
    <a id="save_btn"onclick={save}>save</a>
  </div>

  <script>
  var self = this;
  self.show_editor=false;
  self.editor=""

  close(e){
    self.show_editor=false;
  }

  self.on('update, mount',function(){
    console.log('editor mounting');
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/javascript");
    editor.container.style.fontFamily = "monospace"
    self.editor=editor;
    $('#editor_panel').drags();
  });

  save(e){
    rc.trigger("data_process:save",{data:self.data, code:self.editor.getValue()});
  }

  rc.on("editor:show",function(params){
    console.log(params)
    self.editor.setValue(params.item.data_process.success);
    self.show_editor=true;
    self.update();
  });
  </script>

</editor>
