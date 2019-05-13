// datas 是二维数组
function wrapTable(headers, datas) {
	if (datas.length>0 && headers.length != datas[0].length) {
		console.log("文不对题")
		return;
	}
	var content = "<table class=\"table  table-bordered table-hover table-card-like\">";
	//标题
	var head = "<thead><tr>"
	for (var txt in headers) {
		head = head + "<th>" + headers[txt] + "</th>";
	}
	head =head + "</tr></thead>"
	content = content + head;
	//body
	var body = "<tbody>";
	for (var i = 0; i < datas.length; i++) {
		//起行
		var title = headers[i];
		var row = datas[i];
		body = body + "<tr>";
		for (var j=0;j<row.length;j++) {
			var data = row[j];
			body = body + "<td data-title=\""+title +"\">";
			body = body + data;
			body = body + "</td>";
		}
		body = body + "</tr>";
	}
	body = body + "</tbody>";
	content = content + body;
	content = content + "</table>";
	return content;
}
