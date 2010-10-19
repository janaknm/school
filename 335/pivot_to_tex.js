function p() {
var rows = document.forms['theSpreadsheet1'].children[0].children[0].children;
var s = "";
var searching_rows = true, searching_cols;
var i, j, ncols=0;
for(i=0; i<rows.length && searching_rows; i++) {
	var row = rows[i],
	    cols = rows[i].children,
	    value;
	searching_cols = true;
	for(j=0; j<cols.length && searching_cols; j++) {		
		value = cols[j].children[0].value;
		if (value.length > 0) {		
			if (j != 0) s += " & ";
			s += value;
		} else {
			if (j == 0) searching_rows = false;
			searching_cols = false;
		}	
	}
	ncols = (j > ncols) ? j : ncols;
	if(searching_rows) {
		s += '\\\\\n';
		if (i == 0) s += '\\hline\n';
	}
}
var out = "\\begin{center}\n\\begin{tabular}{| c |";
for (var i=1; i < ncols-1; i++) {
	out += " c ";
}
out += "|}\n\\hline\n" + s + "\\hline\n\\end{tabular}\n\\end{center}";
console.log(out);
}
p()

