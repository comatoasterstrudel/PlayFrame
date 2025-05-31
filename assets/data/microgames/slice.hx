var bg:FlxSprite;
var shroud:FlxSprite;
var arrow:FlxSprite;
var warn:FlxSprite;

var canControl:Bool = true;

var goodTiming:Bool = false;

var won:Bool = false;

function create():Void{
    PlayState.wonMicrogame = false;

    bg = new FlxSprite().makeGraphic(frameWidth, frameHeight);
    microgameGroup.add(bg);
    
    shroud = new FlxSprite();
    shroud.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/slice/shroud.png', 'assets/images/microgames/slice/shroud.xml');
    shroud.animation.addByPrefix('idle', 'idle', 3 * PlayState.additiveSpeed);
    shroud.animation.addByPrefix('hit', 'hit', 12 * PlayState.additiveSpeed, false);
    shroud.animation.addByPrefix('dodge', 'dodge', 12 * PlayState.additiveSpeed, false);
    shroud.animation.addByPrefix('fuck', 'fuck', 10 * PlayState.additiveSpeed, false);
    shroud.animation.play('idle');
    Utilities.centerSpriteOnPos(shroud, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(shroud);
    
    arrow = new FlxSprite();
    arrow.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/slice/arrow.png', 'assets/images/microgames/slice/arrow.xml');
    arrow.animation.addByPrefix('idle', 'idle', 20 * PlayState.additiveSpeed, false);
    arrow.animation.play('idle');
    Utilities.centerSpriteOnPos(arrow, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(arrow);
    
    arrow.visible = false;
    
    warn = new FlxSprite().loadGraphic('assets/images/microgames/slice/warn.png');
    Utilities.centerSpriteOnPos(warn, frameWidth / 2, frameHeight / 2);
    warn.alpha = 0;
    microgameGroup.add(warn);
    
    new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
    {        
        playSound('assets/sounds/warn.ogg', .7);
        warn.alpha = 1;
        FlxTween.tween(warn, {alpha: 0}, .6 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut, onComplete: function(f):Void{
            new FlxTimer().start(PlayState.harder ? (FlxG.random.float(.1, .3) * PlayState.subtractiveSpeed) : 0, function(tmr:FlxTimer){
                arrow.visible = true;
                arrow.animation.play('idle', true);
                playSound('assets/sounds/arrow.ogg', .5);

                if(PlayState.harder){
                    arrow.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int):Void{
                        if(frameNumber > 1){
                            goodTiming = true;    
                        }
                    };
                } else {
                    goodTiming = true;   
                }            
                
                arrow.animation.finishCallback = function(name:String):Void{
                    if(!won){
                        arrow.visible = false;
                        canControl = false;
                        shroud.animation.play('dodge');
                        playSound('assets/sounds/misshsroud.ogg', 1);
                    }
                };
            });
        }});
    });
}

function update(elapsed:Float):Void{
    if(canControl){
        if(Controls.getControl('ACCEPT', 'RELEASE') || Controls.getControl('UP', 'RELEASE') || Controls.getControl('DOWN', 'RELEASE') || Controls.getControl('LEFT', 'RELEASE') || Controls.getControl('RIGHT', 'RELEASE')){
            if(goodTiming){
                PlayState.wonMicrogame = true;
                shroud.animation.play('hit'); 
                arrow.visible = false; 
                won = true;
                playSound('assets/sounds/shroudkill.ogg', 1);
                shroud.animation.finishCallback = function(name:String):Void{
                    shroud.visible = false;
                };
            } else {
                shroud.animation.play('fuck');  
                canControl = false;
                playSound('assets/sounds/whiff.ogg', .6);
            }
        }
    }
}

function endMicrogame():Void{

}

function destroyMicrogame():Void{
    shroud.destroy();
    arrow.destroy();
    warn.destroy();
    bg.destroy();
}