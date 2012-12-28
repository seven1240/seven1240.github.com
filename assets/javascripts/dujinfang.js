
// Nav bar auto active
$(function() {
	var a1 = document.URL;
	var a2 = $("#nav a");
	console.log(a1);
	for (var i = 1; i < a2.length; i++) {
		if (a1.indexOf($(a2[i]).attr("href")) != -1) {
			$(a2[i]).parent().addClass("active");
			return;
		}
	}
	$(a2[0]).parent().addClass("active");
})
