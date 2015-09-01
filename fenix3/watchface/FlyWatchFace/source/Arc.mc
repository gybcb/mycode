using Graphics as Gfx;

class Arc
{
    // just for efficiency
    hidden var coords = [
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ]
    ];
    

    function makeArcPoints(n, theta, phi) {
	var points = new [n + 1];
	for (var i = 0; i <= n; ++i) {
	    var radians = theta + (i * phi) / n;
	    
	    var px =  Math.sin(radians);
	    var py = -Math.cos(radians);
	    
	    points[i] = [ px, py ];
	}
	
	return points;
    }

    function fillArcFromPoints(dc, points, cx, cy, r1, r2, min, max) {
	for (var i = min + 1; i <= max; ++i) {
	    coords[0][0] = cx + (points[i - 1][0] * r1);
	    coords[0][1] = cy + (points[i - 1][1] * r1);
	    
	    coords[1][0] = cx + (points[i - 1][0] * r2);
	    coords[1][1] = cy + (points[i - 1][1] * r2);
	    
	    coords[2][0] = cx + (points[i    ][0] * r2);
	    coords[2][1] = cy + (points[i    ][1] * r2);
	    
	    coords[3][0] = cx + (points[i    ][0] * r1);
	    coords[3][1] = cy + (points[i    ][1] * r1);
	    
	    coords[4][0] = coords[0][0];
	    coords[4][1] = coords[0][1];
	    
	    dc.fillPolygon(coords);
    	}
}
