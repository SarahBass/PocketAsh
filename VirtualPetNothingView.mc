import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;
import Toybox.UserProfile;
class VirtualPetNothingView extends WatchUi.WatchFace {
  
function initialize() {  WatchFace.initialize(); }

function onLayout(dc as Dc) as Void { }

function onShow() as Void { }

function onUpdate(dc as Dc) as Void {
/*                 _       _     _           
  __   ____ _ _ __(_) __ _| |__ | | ___  ___ 
  \ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
   \ V / (_| | |  | | (_| | |_) | |  __/\__ \
    \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/
                                           */

    /*----------System Variables------------------------------*/
    var mySettings = System.getDeviceSettings();
    var myStats = System.getSystemStats();
    var info = ActivityMonitor.getInfo();
    var screenHeightY = (System.getDeviceSettings().screenHeight)/360;
    var screenWidthX = (System.getDeviceSettings().screenWidth)/360;
    
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
    if (System.getDeviceSettings().screenHeight ==390){
        screenHeightY=screenHeightY*1.1;
        screenWidthX=screenWidthX *1.07;
    }
    if (System.getDeviceSettings().screenHeight ==416){
        screenHeightY=screenHeightY*1.15;
        screenWidthX=screenWidthX *1.17;
    }
    if (System.getDeviceSettings().screenHeight ==454){
        screenHeightY=screenHeightY*1.25;
        screenWidthX=screenWidthX *1.27;
    }

    
    /*----------Clock and Calendar Variables------------------------------*/
    //var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var hours = clockTime.hour;
    if (!System.getDeviceSettings().is24Hour) {
        if (hours == 0) {
            hours = 12; // Display midnight as 12:00
        } else if (hours > 12) {
            hours = hours - 12;
        }
    } else {
       // timeFormat = "$1$:$2$";
        hours = hours.format("%02d");
    }
    //var timeStamp= new Time.Moment(Time.today().value());
    var weekdayArray = ["Day", "SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"] as Array<String>;
    var monthArray = ["Month", "JAN", "FEB", "MAR", "APR", "MAY", "JUNE", "JULY", "AUG", "SEP", "OCT", "NOV", "DEC"] as Array<String>;
    

    /*----------Battery------------------------------*/
    var userBattery = "0";
    if (myStats.battery != null) {
        userBattery = myStats.battery.toNumber().toString(); // Convert to string without zero padding
    } else {
        userBattery = "0";
    }
        
    /*----------Steps------------------------------*/
    var userSTEPS = 0;
    if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 
   
   /*----------Calories------------------------------*/
    var userCAL = 0;
    if (info.calories != null){userCAL = info.calories.toNumber();}else{userCAL=0;}  
   
/*----------Heart-----------------------------*/
    var userHEART = "--";
    var heartRate = getHeartRate();
    if (heartRate == null) {
        userHEART = "--"; // Set to "0" if heart rate is unavailable
    } else { userHEART = heartRate.toString(); }
/*----------Alarms and Notify------------------------------*/
    var userNotify = "0";
    if (mySettings.notificationCount != null) {
        userNotify = Lang.format("$1$", [mySettings.notificationCount.toNumber().format("%2d")]);
    }

    var userAlarm = "0";
    if (mySettings.alarmCount != null) {
        userAlarm = Lang.format("$1$", [mySettings.alarmCount.toNumber().format("%2d")]);
    }
    //--------------------Phone and Battery Charge-------/
    // Default color (black) in case of any null issues
    var phoneColor = 0x000000;
    var chargeColor= 0x000000;

    // Check if `mySettings` and `myStats` are not null
    // Set color based on connection and charging status
    if (myStats.charging != null && myStats.charging== true) {
       chargeColor = 0xADE75A; } // Green if charging
       else{chargeColor= 0x000000;}
      
    if (mySettings.phoneConnected!= null && mySettings.phoneConnected == false) {
        phoneColor = 0xD65231;} // Red if phone is disconnected 
    else{phoneColor = 0x000000;}


    /*----------Font------------------------------*/
    var centerX = (dc.getWidth()) / 2;
    var wordFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
    var bigFont= WatchUi.loadResource( Rez.Fonts.bigFont );
    var smallFont =  WatchUi.loadResource( Rez.Fonts.xsmallFont );
    View.onUpdate(dc);

 /*     _                           _            _    
     __| |_ __ __ ___      __   ___| | ___   ___| | __
    / _` | '__/ _` \ \ /\ / /  / __| |/ _ \ / __| |/ /
   | (_| | | | (_| |\ V  V /  | (__| | (_) | (__|   < 
    \__,_|_|  \__,_| \_/\_/    \___|_|\___/ \___|_|\_\
                                                   */
   
    var dog = dogPhase(today.sec, (today.sec*180)); //userSTEPS or (today.sec*180)
    dog.draw(dc);
    var sprite = spritePhase(today.sec); //userSTEPS or (today.sec*180)
    sprite.draw(dc);
    dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(centerX*0.3, centerX,centerX*0.87 ) ;
    dc.setPenWidth(8);
    dc.setColor(0xA5D6FF, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(centerX*0.3, centerX,centerX *0.87) ;
    dc.setColor(0xC8E0D8, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(centerX*0.3, centerX,centerX *0.89) ;
    dc.setColor(0x84F7B5, Graphics.COLOR_TRANSPARENT);
    dc.drawArc(centerX*0.3, centerX, centerX*0.89, Graphics.ARC_COUNTER_CLOCKWISE, 1, (userSTEPS+2) ); 
    //Grass Green: ADE75A
    //Water blue: Lightblue A5D6FF
    //green gray: 7B7B94
    //Pallet Town : A0D0F8 and C8E0D8
    //teal: 84F7B5
    /*------------Draw TEXT -------------*/

    dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT); //orange 0xF79400
    //Time Text
    dc.drawText(50*screenWidthX, 90*screenHeightY,bigFont, hours.format("%02d"),  Graphics.TEXT_JUSTIFY_CENTER  );
    dc.drawText(50*screenWidthX, 140*screenHeightY,bigFont, clockTime.min.format("%02d"),  Graphics.TEXT_JUSTIFY_CENTER  );
    dc.drawText(50*screenWidthX,210*screenHeightY,smallFont,(weekdayArray[today.day_of_week]), Graphics.TEXT_JUSTIFY_CENTER );
    dc.drawText(50*screenWidthX,228*screenHeightY,smallFont,(monthArray[today.month]+" "+ today.day +" " +today.year), Graphics.TEXT_JUSTIFY_CENTER );
     dc.setColor(chargeColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(50*screenWidthX, 245*screenHeightY,wordFont,("#"), Graphics.TEXT_JUSTIFY_RIGHT );
     dc.setColor(phoneColor, Graphics.COLOR_TRANSPARENT);
    dc.drawText(50*screenWidthX, 245*screenHeightY,wordFont,("+"), Graphics.TEXT_JUSTIFY_LEFT );
    // Data Text
    if(today.sec%7 == 0 ||today.sec%7 == 6){dc.setColor(0xD65231, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);} //red cinabar 0xD65231
    dc.drawText(121*screenWidthX, 35*screenHeightY, wordFont,  (userHEART+"^"), Graphics.TEXT_JUSTIFY_RIGHT );
    if(today.sec%7 == 1||today.sec%7 == 6){dc.setColor(0xF79400, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);}
    //dc.setColor(0xF79400, Graphics.COLOR_TRANSPARENT); //orange 0xF79400
    dc.drawText(160*screenWidthX, 67*screenHeightY, wordFont,  (userCAL+"!"), Graphics.TEXT_JUSTIFY_RIGHT ); 
    //dc.setColor(0xDEDE18, Graphics.COLOR_TRANSPARENT); //yellowLime 0xDEDE18
    if(today.sec%7 == 2||today.sec%7 == 6){dc.setColor(0xDEDE18, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);}
    dc.drawText(180*screenWidthX, 115*screenHeightY, wordFont,  (userBattery+"*"), Graphics.TEXT_JUSTIFY_RIGHT ); 
    //dc.setColor(0xADE75A, Graphics.COLOR_TRANSPARENT); //green 0xADE75A
     if(today.sec%7 == 3||today.sec%7 == 6){dc.setColor(0xADE75A, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);}
    dc.drawText(200*screenWidthX, (centerX-15), wordFont, (userSTEPS+"$"), Graphics.TEXT_JUSTIFY_RIGHT ); 
    //dc.setColor(0x8CA5F7, Graphics.COLOR_TRANSPARENT); //blue 0x8CA5F7
    if(today.sec%7 == 4||today.sec%7 == 6){dc.setColor(0x8CA5F7, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);}
    dc.drawText(180*screenWidthX, 215*screenHeightY, wordFont, (userNotify+"_"), Graphics.TEXT_JUSTIFY_RIGHT ); 
    //dc.setColor(0xC673C6 , Graphics.COLOR_TRANSPARENT); //lavendar 0xC673C6
   if(today.sec%7 == 5||today.sec%7 == 6){dc.setColor(0xC673C6, Graphics.COLOR_TRANSPARENT);}else{dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);}
    dc.drawText(150*screenWidthX, 265*screenHeightY, wordFont, (userAlarm+">"), Graphics.TEXT_JUSTIFY_RIGHT ); 
    
    
    /*calories exclaim
    #charge
    $foot
    >alarm
    *battery
    ^heart
    _new message
    +phone
    = large alarmring
    */

}
/*            _     _ 
  __   _____ (_) __| |
  \ \ / / _ \| |/ _` |
   \ V / (_) | | (_| |
    \_/ \___/|_|\__,_|
                    */

function onHide() as Void { }
function onExitSleep() as Void {}
function onEnterSleep() as Void {}


/*     _                                        
    __| |_ __ __ ___      __  _ __  _ __   __ _ 
   / _` | '__/ _` \ \ /\ / / | '_ \| '_ \ / _` |
  | (_| | | | (_| |\ V  V /  | |_) | | | | (_| |
   \__,_|_|  \__,_| \_/\_/   | .__/|_| |_|\__, |
                             |_|          |___/ */

//DrawOpacityGraphic - dog -
function dogPhase(seconds, steps){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2X = (40);
  var venus2Y = 0-(seconds*4);
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
  if (screenHeightY == 390){
    venus2X = (60);
    }
    if (screenHeightY == 416){
    venus2X = (95);
    }
    if (screenHeightY == 454){
    venus2X = 130;
    }
  var dogARRAY = [
    (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog0,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog2,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog3,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog4,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog5,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog6,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog7,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog8,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog9,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog10,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog11,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog12,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog13,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog14,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog15,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog16,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog17,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog18,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog19,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog20,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog21,
            :locX=> venus2X,
            :locY=>(venus2Y-2)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog22,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog23,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog24,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog25,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog26,
            :locX=> (venus2X-4),
            :locY=>(venus2Y-3)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog27,
            :locX=> (venus2X-4),
            :locY=>(venus2Y-3)
        })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.dog28,
            :locX=> (venus2X-3),
            :locY=>(venus2Y-4)
        }))
        ];
       if (steps >= 10000){return dogARRAY[28];}
       else{return dogARRAY[((steps/360)) ];}
        
        
  
}

function spritePhase(seconds){
  var screenHeightY = System.getDeviceSettings().screenHeight;
  var screenWidthX = System.getDeviceSettings().screenWidth;
  var venus2X = (200);
  var venus2Y = (seconds*40);
  if (seconds>20) {venus2Y= 600-(seconds*30);}
  else{venus2Y = (seconds*40);}
    //Size Variations Pixel Circle
    //360 VenuS2 - The Model I designed it for 
    //390 Size up
    //416 Size up
    //454 Size up
  if (screenHeightY == 390){
    venus2X = 220;
    }
    if (screenHeightY == 416){
    venus2X = 250;
    }
    if (screenHeightY == 454){
    venus2X = 270;
    }
var spriteARRAY = [
    (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sprite0,
            :locX=> venus2X,
            :locY=>venus2Y
            })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sprite1,
            :locX=> venus2X,
            :locY=>venus2Y
            })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sprite2,
            :locX=> venus2X,
            :locY=>venus2Y
            })),
            (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.sprite3,
            :locX=> venus2X,
            :locY=>venus2Y
            }))
        ];
       if(seconds>20){
        return spriteARRAY[(2+seconds%2)];
       }else{
       return spriteARRAY[(seconds%2)];}
       }

/* _                     _       __       _       
  | |__   ___  __ _ _ __| |_    /__\ __ _| |_ ___ 
  | '_ \ / _ \/ _` | '__| __|  / \/// _` | __/ _ \
  | | | |  __/ (_| | |  | |_  / _  \ (_| | ||  __/
  |_| |_|\___|\__,_|_|   \__| \/ \_/\__,_|\__\___|
                                                */

private function getHeartRate() {
    // Initialize to null
    var heartRate = null;

    // Get the activity info if possible
    var info = Activity.getActivityInfo();
    if (info != null && info.currentHeartRate != null) {
        heartRate = info.currentHeartRate;
    } else { 
        // Fallback to `getHeartRateHistory`
        var history = ActivityMonitor.getHeartRateHistory(1, true);
        if (history != null) {
            var latestHeartRateSample = history.next();
            if (latestHeartRateSample != null && latestHeartRateSample.heartRate != null) {
                heartRate = latestHeartRateSample.heartRate;
            }
        }
    }

    // Could still be null if the device doesn't support it
    return heartRate;
}


}
