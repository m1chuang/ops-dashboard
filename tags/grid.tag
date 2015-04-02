
<grid>

  <style>
    #items *{
      font-size:10px;
      line-height: 1em;
    }
    raw{
      display:inline-block;
      width:100%;
      font-size:10px;
      line-height: 1em;
      overflow:scroll;
    }
    .controls{
      display:none;
      background:rgb(205, 205, 205);
    }

    input, form{
      line-height: 1em;
    }
    .grid-container label{
      font-size:10px;
      display: inline-block;
      width:100%;
      margin-bottom:5px;
    }
    table {
      border: 1px solid #666;
      width: 100%;
    }
    th {
      background: #f8f8f8;
      font-weight: bold;
      padding: 2px;
    }
    #close_edit{
      color:red;
    }
    .block_header {
  padding: 0.5em;
  font-size: 1.5em !important;
  color: white;
  text-align: left;
  background: rgb(236, 170, 83);
}
  #save_dashboard{
    background: white;
    border: 1px solid black;
    cursor: pointer;
  }
  button{
    height: 100%;
  margin-left: 1em;
}
  </style>

  <div class="header">
    <!-- add block control -->
    <a href="#remove-item" class="button remove-item">-item</a>
    <a href="#add-item" class="button add-item" onclick={ add }>+item</a>
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
      <option value="0">freeform</option>
      <option value="3">image</option>
      <option value="4">pageDuty</option>
      <option value="5">Jira</option>
    </select>
    <button onclick={save_dashboard} >Save edit</button>
    <button id="edit" onclick={edit} >edit</button>
    <!-- end of add block control -->
  </div>
  <div class="grid-container">
    <ul id="items" class="grid">
      <li class="position-highlight">
        <div class="inner"></div>
      </li>

      <li class="block" each={items} id="{id}" data-w="{position.w}" data-h="{position.h}" data-x="{position.x}" data-y="{position.y}">
        <div class="inner">
          <!-- block control -->
          <div class="controls">
            <label for="new_block_h">width
              <a href="#zoom1" onclick={parent.resize}  data-size="1">1x</a>
              <a href="#zoom2" onclick={parent.resize}  data-size="2">2x</a>
              <a href="#zoom3" onclick={parent.resize} data-size="3">3x</a>
            </label>

            <a id="close_edit" onclick={parent.close_edit}>close</a>
            <a id="refresh" onclick={parent.refresh}>refresh</a>
            <a id="code" onclick={parent.code}>code</a>
            <a id="delete" onclick={parent.remove}>Delete</a>
          </div>
          <!-- end of block control -->
          <div contenteditable="true" class="block_header">{header}</div>
          <p contenteditable="true" if={type==2}>{"add content" || content_html}</p>
          <raw content="{ data_process.content_html || content_html}" data-raw="{ content_raw}"/>

        </div>
      </li>

    </ul>
  </div>

  <script>
    var self = this;
    self.items =opts.items || [];
    self.currentSize=opts.size;

    resize(e){
      self.items[e.item.id].w=$(e.currentTarget).data('size');
      console.log('resizing...')
      console.log(self.items[e.item.id].w)
      self.update()
    };

    edit(e){
      $(".controls").show();
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
        id:this.items.length,
        position:{
          w: parseInt(this.new_block_w.value,10),
          h: parseInt(this.new_block_h.value,10),
          x: _empty_right,
          y: 0
        },
        type:parseInt(this.block_type.value,10),
        content_html:"",
        data_process:{}
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
      //this.update();
    });

    this.on('update',function(data){
      console.log('updating')
      console.log(data)
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

        }
      });
      console.log('Grid updating');
    });

    rc.on('block:change',function(items){
      self.items = items;
      console.log("block:change");
      console.log(items);
      console.log(self.items);
      self.update();
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
