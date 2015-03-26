<editor>
  <style type="text/css" media="screen">
      #editor {
        position: absolute;
        height:100%;
        width: 100%;
      }
      #editor_panel{
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;

        left: 50%;
        transform: translateX(-50%);
        top:20%;
        height:60%;
        font-family:monospace !important;
      }
      #close_btn{
        position:absolute;
        right: -1em;
        font-size: 2em;
        color: red;
        background: white;
        border: 1px solid black;
        cursor: pointer;
      }
  </style>

  <div id="editor_panel" >
    <div id="editor">{opt.code}</div>
    <a id="close_btn"onclick={close}>x</a>
  </div>

  <script>
  close(e){
    $(this.editor_panel).hide();
  }
  this.on('mount',function(){
    console.log('editor mounting');
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/javascript");
    editor.container.style.fontFamily = "monospace"
  });
  </script>

</editor>
