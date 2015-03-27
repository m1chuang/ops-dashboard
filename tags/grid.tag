
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
    </select>
    <label for="new_block_h">height</label>
    <select name="new_block_h">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3" selected>3</option>
    </select>
    <label for="block_type">type</label>
    <select name="block_type">
      <option value="1" selected>quickBase</option>
      <option value="2">Form</option>
      <option value="3">Form</option>
    </select>
    <!-- end of add block control -->
  </div>
  <div class="grid-container">
    <ul id="items" class="grid">
      <li class="position-highlight">
        <div class="inner"></div>
      </li>

      <li class="block" each={ item, i in items } id={i} data-w="{item.position.w}" data-h="{item.position.h}" data-x="{item.position.x}" data-y="{item.position.y}" >
        <div class="inner">
          <div class="controls">
            <label for="new_block_h">width
              <a href="#zoom1" onclick={parent.resize}  data-size="1">1x</a>
              <a href="#zoom2" onclick={parent.resize}  data-size="2">2x</a>
              <a href="#zoom3" onclick={parent.resize} data-size="3">3x</a>
            </label>

            <qbcontrol if={item.type==1}></qbcontrol>
            <a id="close_edit" onclick={parent.close_edit}>close</a>
            <a id="refresh" onclick={parent.refresh}>refresh</a>
            <a id="code" onclick={parent.code}>code</a>
          </div>

          <raw content="{ item.content_html }" data-raw="{ item.content_raw}"/>
          <a id="edit" onclick={parent.edit}>edit</a>
        </div>
      </li>

    </ul>
  </div>

  <script>
    var self = this;
    self.items =opts.items || [];
    self.currentSize=opts.size;

    resize(e){
      self.items[e.item.i].w=$(e.currentTarget).data('size');
      self.update()
    };

    edit(e){
      $('li#'+e.item.i+" .controls").show();
    };

    close_edit(e){
      $('li#'+e.item.i+" .controls").hide();
    };

    refresh(e){

      var block = window.localStorage.getItem("block_"+e.item.i);
      rc.trigger("api:"+block.api,{});
      var block_data = JSON.parse(window.localStorage.getItem("block_data_"+e.item.i));
      console.log(e.item);
      $('li#'+e.item.i+" raw")[0].innerHTML = eval($('li#'+e.item.i+" raw").attr('data-raw'));
    };

    code(e){
      rc.trigger("editor:show",{item:e.item.item});
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
      //this.grid.items.push(itemData);
      //this.grid.num_items=this.grid.num_items+1;
      $('.grid-container').scrollLeft($('.grid-container').width());
    }

    this.on('mount',function(){
      console.log('Grid mounting');
      this.update();
    });

    this.on('update',function(data){
      $('#items').gridList({
        rows: this.currentSize,
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
      items.forEach(function(item,i){
        if(self.items[item.id]){
          self.items[item.id]=item;
        }else{
          self.items.push(item);
        }
      });
      console.log("block:change");
      console.log(items);
      self.update();
      self.update();
    });

    rc.on('block:render',function(block_id){
      self.update();
    });
  </script>
</grid>

<raw>
  <span></span>
  this.root.innerHTML = opts.content
</raw>

<qbcontrol>
  <form>
    <label for="new_block_h">months
      <input name="months"></input>
    </label>
    <label for="new_block_h">query
      <input name="query"></input>
    </label>
    <label for="new_block_h">clist
      <input name="clist"></input>
    </label>
    <label for="new_block_h">slist
      <input name="slist"></input>
    </label>
  </form>

</qbcontrol>
