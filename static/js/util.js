var create_table = function drawRow(tableData) {
	console.log('in create table')
	var data = tableData.data;
	var names = tableData.names;
	var html = '';
	var row = [];
	html += "<tr>";
	for (item in names) {
		html += "<th>" + names[item] + "</th>";

	}
	html += "</tr>";
	for (item in data) {
		html += "<tr>";
		html += "<td>" + item + "</td>"
		for (key in data[item]) {
			html += "<td>" + data[item][key] + "</td>"
		}
		html += "</tr>";
	}
	return "<table>" + html + "</table>"
}



//draggable debug console
//(function($) {
$.fn.drags = function(opt) {

		opt = $.extend({
			handle: "",
			cursor: "move"
		}, opt);

		if (opt.handle === "") {
			var $el = this;
		} else {
			var $el = this.find(opt.handle);
		}

		return $el.css('cursor', opt.cursor).on("mousedown", function(e) {
			$('.block').css('pointer-event', 'none');
			if (opt.handle === "") {
				var $drag = $(this).addClass('draggable');
			} else {
				var $drag = $(this).addClass('active-handle').parent().addClass(
					'draggable');
			}
			var z_idx = $drag.css('z-index'),
				drg_h = $drag.outerHeight(),
				drg_w = $drag.outerWidth(),
				pos_y = $drag.offset().top + drg_h - e.pageY,
				pos_x = $drag.offset().left + drg_w - e.pageX;
			$drag.css('z-index', 1000).parents().on("mousemove", function(e) {
				$('.draggable').offset({
					top: e.pageY + pos_y - drg_h,
					left: e.pageX + pos_x - drg_w
				}).on("mouseup", function() {
					$(this).removeClass('draggable').css('z-index', z_idx);
				});
			});
			e.preventDefault(); // disable selection
		}).on("mouseup", function() {
			$('.block').css('pointer-event', 'initial');
			if (opt.handle === "") {
				$(this).removeClass('draggable');
			} else {
				$(this).removeClass('active-handle').parent().removeClass('draggable');
			}
		});

	}
	//})(jQuery);
