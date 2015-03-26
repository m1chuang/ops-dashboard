
var create_table = function drawRow(tableData) {
    var data = tableData.data;
    var names = tableData.names;
    var html = '';
    var row=[];
    html+="<tr>";
    for(item in names){
      html+="<th>"+names[item]+"</th>";

    }
    html+="</tr>";
    for(item in data){
      html+="<tr>";
      html+="<td>"+item+"</td>"
      for(key in data[item]){
        html+="<td>"+data[item][key]+"</td>"
      }
      html+="</tr>";
    }
    return "<table>"+html+"</table>"
}
