
<grid>

  <style>
    body{
      /*background: rgb(138, 144, 161);*/
      font-family: 'Signika Negative', sans-serif;
    }
    raw canvas{
      display:inline-block;
      width:100% !important;
      height:100% !important;
    }
    .blockcontent{
      display:inline-block;
      width:100%;
      max-height: 91%;
      height: 100%;
      font-weight: 300;
    }
    .controls{
      display:none;
      background:rgb(146, 186, 207);
      height:100%;
      width:9em;
    }
    .grid-container label{
      font-size:10px;
      display: inline-block;
      width:100%;
      margin-bottom:5px;
    }
    table {
      width: 100%;
      height:100%;
      border-collapse: collapse;
    }
    tbody {
      width: 100%;
      height:100%;
    }
    th {
      background: #f8f8f8;
      font-weight: bold;
      padding: 2px;
      height:1.3em;
    }
    #close_edit{
      color:red;
    }
    .block_header raw{
      padding-left:1em;
    }
    .block_header {
      max-height: 11%;
      color: white;
      text-align: left;
      background: rgb(226, 169, 122);
      width:100%;

      display:inline-block;
    }
    #save_dashboard{
      background: white;
      border: 1px solid black;
      cursor: pointer;
    }
    button{
      margin-left: 1em;
    }
    .resize a{
      cursor:pointer;
      background:transparent;
      font-size: 1.3em;
      margin-left: 0.5em;
    }
    .resize a:hover{
      color:red;
    }
    .row{˜˜
      width:100%;
      display:inline-block;
    }
    #inner{
      height:100%;
    }
    .close_edit{
      color:red;
    }

    tr:nth-child(even) {background: #ECECEC}
    tr:nth-child(odd) {background: white}


    .item raw.content {
      padding: 0;
      padding-left: 9%;
      width: 91%;
      display: inline-block;
      margin: 0;
    }
    li #numbering {
      position: absolute;
      margin-left: 1em;
    }
    #setting{
      float:right;
      margin:1em;
      cursor:pointer;

    }
    #setting:hover{
      color:red;
    }
    a.control:hover{color:blue;}

  </style>
  <a id="setting" onclick={edit_setting} show={!show_setting}>setting</a>
  <div class="header" show={show_setting}>
    <!-- add block control -->
    <a id="setting" onclick={edit_setting}>close</a>
    <button class="add-item" onclick={ add }>+item</button>
    <label for="new_block_w">width</label>
    <select name="new_block_w">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3" selected>3</option>
      <option value="4">4</option>
    </select>
    <label for="new_block_h">height</label>
    <select name="new_block_h">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3" selected>3</option>
      <option value="4">4</option>
      <option value="5">5</option>
      <option value="6">6</option>
    </select>
    <label for="block_type">type</label>
    <select name="block_type">
      <option value="1" selected>quickBase</option>
      <option value="0">generic API</option>
      <option value="2">freeform</option>
      <option value="5">list</option>
      <option value="3">image</option>
      <option value="4">pageDuty</option>
      <option value="6">Jira</option>
    </select>
    <button onclick={save_dashboard} >Save edit</button>
    <button id="edit" onclick={edit} class="{(editing)?'close_edit':'edit'}">{editing?"Close Edit":"Edit"}</button>
    <!-- end of add block control -->
  </div>
  <div class="grid-container" >
    <ul id="items" class="grid">
      <li class="position-highlight">
        <div class="inner"></div>
      </li>

      <li class="block" each={items} id="{id}" data-w="{position.w}" data-h="{position.h}" data-x="{position.x}" data-y="{position.y}">
        <div class="inner">
          <!-- block control -->
          <div class="controls">
            <label class="row resize">width
              <a onclick={parent.resize_w}  data-size="1">1x</a>
              <a onclick={parent.resize_w}  data-size="2">2x</a>
              <a onclick={parent.resize_w} data-size="3">3x</a>
              <a onclick={parent.resize_w}  data-size="4">4x</a>
              <a onclick={parent.resize_w} data-size="5">5x</a>
            </label>
            <label class="row resize">height
              <a onclick={parent.resize_h}  data-size="1">1x</a>
              <a onclick={parent.resize_h}  data-size="2">2x</a>
              <a onclick={parent.resize_h} data-size="3">3x</a>
              <a onclick={parent.resize_h}  data-size="4">4x</a>
              <a onclick={parent.resize_h} data-size="5">5x</a>
            </label>

            <a class="row control" id="close_edit" onclick={parent.close_edit}>close</a>
            <a class="row control" id="refresh" onclick={parent.refresh}>refresh</a>
            <a class="row control" id="code" onclick={parent.code}>code</a>
            <a class="row control" id="delete" onclick={parent.remove}>Delete</a>
          </div>
          <!-- end of block control -->
          <div id="inner">
            <h3 contenteditable="true" class="block_header" onkeyup={parent.update_content} ><raw content={header}/></h3>

            <p><raw class="blockcontent" content="{ data_process.content || data_process.content_html || content_html}" id="{'content'+String(id)}" data-raw="{ content_raw}"/></p>
          </div>
        </div>
      </li>

    </ul>
  </div>

  <script>
    var self = this;
    self.items =opts.items || [];
    self.currentSize=opts.size;
    self.editing = false;
    self.show_setting = false;
    edit_setting(e){
      self.show_setting = !self.show_setting;
    }
    update_content(e){
      console.log('updating contenteditable...');
      console.log(e.currentTarget.children[0].innerHTML);
      console.log(e.currentTarget.children[0].children[0]);
      console.log(e.currentTarget.children[0].children[0].innerHTML);


      e.item.header = e.currentTarget.children[0].innerHTML;
    }
    edit(e){
      console.log("click header")
        e = e || window.event;
        console.log(e.target.contentEditable)
        e.target.contentEditable = true;
        e.target.focus();
        var caretRange = getMouseEventCaretRange(e);

        // Set a timer to allow the selection to happen and the dust settle first
        window.setTimeout(function() {
            selectRange(caretRange);
        }, 10);
        return false;
    };
    resize_w(e){

      rc.trigger('block:size:change',{id:e.item.id,position:{
        w:$(e.currentTarget).data('size'),
        h:e.item.position.h,
        x:e.item.position.x,
        y:e.item.position.y
        }
      });
    };
    resize_h(e){
      rc.trigger('block:size:change',{id:e.item.id,position:{
        w:e.item.position.w,
        h:$(e.currentTarget).data('size'),
        x:e.item.position.x,
        y:e.item.position.y
        }
      });
    };

    edit(e){
      self.editing? $('.controls').hide():$('.controls').show();
      self.editing=!self.editing;
      self.update();
    };


    close_edit(e){
      $('li#'+e.item.id+" .controls").hide();
    };

    save_dashboard(e){
      rc.trigger('dashboard:save');
    };

    refresh(e){
      var block = window.localStorage.getItem("block_"+e.item.id);
      rc.trigger("api:"+block.api,{});
      var block_data = JSON.parse(window.localStorage.getItem("block_data_"+e.item.id));
      $('li#'+e.item.id+" raw")[0].innerHTML = eval($('li#'+e.item.id+" raw").attr('data-raw'));
    };

    code(e){
      rc.trigger("editor:show",{item:e.item});
    };

    add(e) {
      var _empty_right=0, _x=0;
      $('.block').each(function(i, item){
          var x = parseInt($(item).attr('data-x')),
              w = parseInt($(item).attr('data-w'));
          _x = (_x > x)? _x : x;
          _empty_right = (_x > x)? _empty_right : _x+w;
      });

      var itemData={
        id:lil.uuid(),
        position:{
          w: parseInt(this.new_block_w.value,10),
          h: parseInt(this.new_block_h.value,10),
          x: _empty_right,
          y: 0
        },
        type:parseInt(this.block_type.value,10),
        data_process:{
          content_html:""
        }
      };
      rc.trigger('block:add',itemData);
      $('.grid-container').scrollLeft($('.grid-container').width());
    }

    remove(e){
      // remove from collection
      rc.trigger('block:delete',e.item);
      this.update();
    }

    this.on('mount',function(){
      console.log('Grid mounting');
      $('body').flowtype({

         minFont   : 4,
         maxFont   : 30,
         fontRatio : 30
      });

    });

    this.on('update',function(data){
      console.log('Grid updating');
      console.log(data);

      setTimeout(self.calculate_height,200);
      $('#items').gridList({
        rows: this.currentSize || 6,
        widthHeightRatio: 264 / 294,
        heightToFontSizeRatio: 0.2,

        onChange: function(changedItems) {
          changedItems.forEach(function(item, i){
            $("li#" + item.$element.context.id).attr('data-x', item.x );
            $("li#" + item.$element.context.id).attr('data-y', item.y);
            rc.trigger('block:position:update',[{
              id:item.$element.context.id,
              position:{
                x:item.x,
                y:item.y,
                w:item.w,
                h:item.h
              }
            }]);
          });
        }//eo onChange
      },{handle:'.blockcontent'});

    });
    calculate_height(e){
      console.log('cal height')
      self.items.forEach(function(item,i){
        $("li#" + item.id +' raw').height(2+$("li#" + item.id +' .inner').height()-$("li#" + item.id +' .block_header').height());
      });
    }
    rc.on('block:change',function(items){

      self.items = items;
      console.log("block:change");
      self.update();

    });

    rc.on('block:render',function(block_id){
      //self.update();
    });
  </script>
</grid>

<raw>
  <span></span>
  this.root.innerHTML = opts.content
</raw>
