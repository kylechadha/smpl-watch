import Toybox.ActivityMonitor;
import Toybox.System;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Lang;
import Toybox.Activity;
import Toybox.Position;

module Data {

    function getClockTime() as System.ClockTime {
        return System.getClockTime();
    }

    function getTimeString() as String {
        var ct = System.getClockTime();
        var h = ct.hour;
        if (!System.getDeviceSettings().is24Hour) {
            h = h % 12;
            if (h == 0) { h = 12; }
        }
        return h.format("%d") + ":" + ct.min.format("%02d");
    }

    function getSecondsString() as String {
        return System.getClockTime().sec.format("%02d");
    }

    function getDateString() as String {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
        var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        var dow = days[now.day_of_week - 1];
        var mon = months[now.month - 1];
        var day = now.day.format("%02d");
        return dow + "  " + mon + "  " + day;
    }

    function getDateCompact() as String {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
        var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        return days[now.day_of_week - 1] + " " + months[now.month - 1] + " " + now.day.format("%02d");
    }

    function getMilitaryDate() as String {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        return now.day.format("%02d") + " " + months[now.month - 1] + " " + now.year;
    }

    function getLongDate() as String {
        var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        return now.day_of_week + ", " + now.month + " " + now.day;
    }

    function getSteps() as Number {
        var info = ActivityMonitor.getInfo();
        return (info.steps != null) ? info.steps : 0;
    }

    function getStepGoal() as Number {
        var info = ActivityMonitor.getInfo();
        return (info.stepGoal != null) ? info.stepGoal : 10000;
    }

    function getStepProgress() as Float {
        var goal = getStepGoal().toFloat();
        if (goal <= 0) { return 0.0; }
        var pct = getSteps().toFloat() / goal;
        return (pct > 1.0) ? 1.0 : pct;
    }

    function getHeartRate() as Number {
        // Try current activity HR first
        var info = Activity.getActivityInfo();
        if (info != null && info.currentHeartRate != null) {
            return info.currentHeartRate;
        }
        // Fall back to last known HR from sensor history
        if (ActivityMonitor has :getHeartRateHistory) {
            var hist = ActivityMonitor.getHeartRateHistory(1, true);
            if (hist != null) {
                var sample = hist.next();
                if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                    return sample.heartRate;
                }
            }
        }
        return 0;
    }

    function getBattery() as Number {
        return System.getSystemStats().battery.toNumber();
    }

    function getBatteryFloat() as Float {
        return System.getSystemStats().battery / 100.0;
    }

    function getSunEvent() as String {
        // Show sunrise if before noon, sunset if after
        var ct = System.getClockTime();
        if (!(Weather has :getSunrise) || !(Weather has :getSunset)) {
            return "--:--";
        }

        var now = Time.now();
        var loc = null;

        // Try to get location from weather conditions first (most reliable)
        if (Weather has :getCurrentConditions) {
            try {
                var cond = Weather.getCurrentConditions();
                if (cond != null && cond has :observationLocationPosition) {
                    loc = cond.observationLocationPosition;
                }
            } catch (e) {
                // Location not available
                loc = null;
            }
        }


        // If we don't have a valid location, return placeholder
        if (loc == null) {
            return "--:--";
        }

        try {
            if (ct.hour < 12) {
                var sr = Weather.getSunrise(loc, now);
                if (sr != null) {
                    var srInfo = Gregorian.info(sr, Time.FORMAT_SHORT);
                    return srInfo.hour.format("%d") + ":" + srInfo.min.format("%02d");
                }
            } else {
                var ss = Weather.getSunset(loc, now);
                if (ss != null) {
                    var ssInfo = Gregorian.info(ss, Time.FORMAT_SHORT);
                    return ssInfo.hour.format("%d") + ":" + ssInfo.min.format("%02d");
                }
            }
        } catch (e) {
            // Weather API call failed
            return "--:--";
        }

        return "--:--";
    }

    function getSunIcon() as String {
        var ct = System.getClockTime();
        // Unicode sun/moon symbols aren't available in Garmin fonts
        // We'll use text labels instead
        return (ct.hour < 12) ? "SR" : "SS";
    }

    function getDistance() as String {
        var info = ActivityMonitor.getInfo();
        if (info.distance != null) {
            // distance is in meters, convert to miles
            var miles = info.distance.toFloat() / 1609.34;
            return miles.format("%.1f");
        }
        return "0.0";
    }

    function getCalories() as Number {
        var info = ActivityMonitor.getInfo();
        return (info.calories != null) ? info.calories : 0;
    }

    function getFloors() as Number {
        var info = ActivityMonitor.getInfo();
        return (info.floorsClimbed != null) ? info.floorsClimbed : 0;
    }

    function formatNumber(n as Number) as String {
        if (n >= 10000) {
            return (n / 1000).format("%d") + "," + (n % 1000).format("%03d");
        } else if (n >= 1000) {
            return (n / 1000).format("%d") + "," + (n % 1000).format("%03d");
        }
        return n.format("%d");
    }
}
