using Toybox.Graphics as Gfx;

class GraphBattery
{
    hidden var batt_width_rect = 20;
    hidden var batt_height_rect = 10;
    hidden var batt_height_rect_small = 5;
    hidden var batt_width_rect_small = 1;
    hidden var batt_x, batt_y, batt_x_small, batt_y_small;
    hidden var batt_primaryColor, batt_lowBatterColor, batt_backgroundColor;
    hidden var batt_stats;
    hidden var batt_showlabel = false;

    function initialize(x, y){
	batt_x = x;
	batt_y = y;

	batt_x_small = batt_x + batt_width_rect;
	batt_y_small = batt_y + ((batt_height_rect - batt_height_rect_small) / 2);
    }

    function setColor(color){
	batt_primaryColor = color;
	batt_lowBatterColor = batt_primaryColor | 0xFF0000;
	batt_backgroundColor = 0xFFFFFF;
    }

    function setBatteryStats(stats){
	batt_stats = stats;
    }

    function setShowStatsLabel(isShow){
	batt_showlabel = isShow;
    }

    // ����
    function draw(dc){
	drawBattery(dc, batt_primaryColor, batt_lowBatterColor);
    }

    function drawBattery(dc, primaryColor, lowBatteryColor)
    {
    	if(batt_stats < 15.0)
    	{
    	    primaryColor = lowBatteryColor;
    	}

    	dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x, batt_y, batt_width_rect, batt_height_rect);
        dc.setColor(batt_backgroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small-1, batt_y_small+1, batt_x_small-1, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.drawRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        dc.setColor(batt_backgroundColor, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(batt_x_small, batt_y_small+1, batt_x_small, batt_y_small + batt_height_rect_small-1);

        dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(batt_x + 2, batt_y + 2, (batt_width_rect * batt_stats / 100) - 4, batt_height_rect - 4);
        if(batt_stats == 100.0)
        {
            dc.fillRectangle(batt_x_small, batt_y_small, batt_width_rect_small, batt_height_rect_small);
        }

	if (batt_showlabel)
	{
	    dc.setColor(primaryColor, Gfx.COLOR_TRANSPARENT);

	    var statsText = batt_stats.format("%.2d") + "%";
	    dc.drawText(batt_x, batt_y + 5, Gfx.FONT_XTINY, statsText, Gfx.TEXT_JUSTIFY_LEFT);
	}
    }

}
