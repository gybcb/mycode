using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;

class FlyWatchFaceView extends Ui.WatchFace {

    hidden var font;
    hidden var graphBattery;
    
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        font = Ui.loadResource(Rez.Fonts.DigitalFont);

	graphBattery = new GraphBattery(150, 35);

	graphBattery.setColor(0x00AA00);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // 设置时间
        var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);
        view.setFont(font);
        
        // 设置星期
        var now = Time.now();
	var info = Calendar.info(now, Time.FORMAT_LONG);
	var xqStr = Lang.format("$1$", [info.day_of_week]);
	view = View.findDrawableById("xq");
	view.setText(xqStr);
	
	// 设置日期
	var dateStr = info.month.toString() + " " + info.day.toString(); 
	view = View.findDrawableById("Date");
	view.setText(dateStr);

	// 设置行走的公里数和消耗的卡路里		
	var activeinfo = ActivityMonitor.getInfo();
	var distanceKm = activeinfo.distance / 1000 / 1000;
	var kmStr = distanceKm.format("%.2f") + "Km";
	var calStr = activeinfo.calories.toString() + "cal ";
	view = View.findDrawableById("walk_km");
	view.setText(kmStr);
	view = View.findDrawableById("walk_cal");
	view.setText(calStr);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

	// 绘制电池
	var batterystate = Sys.getSystemStats().battery;
	graphBattery.setBatteryStats(batterystate);
	graphBattery.setShowStatsLabel(true);
	graphBattery.draw(dc);


    }



    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

    //! Generate an array of points on an arc sweeping phi radians starting at theta
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
    
    // just for efficiency
    hidden var coords = [
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ],
	[ 0, 0 ]
    ];

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
}
