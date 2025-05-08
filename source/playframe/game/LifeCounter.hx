package playframe.game;

/**
 * the class that holds the life counter and avatar portrait
 */
class LifeCounter extends FlxTypedGroup<FlxSprite> 
{
    /**
     * the character portrait for your current avatar
     */
    public var portrait:FlxSprite;
    
    /**
     * an array of all the live sprites
     */
    public var lives:Array<FlxSprite> = [];
    
    /**
     * the sprite that displays your characters name
     */
    public var namePlate:FlxSprite;
    
    /**
     * How big the lives are supposed to be
     */
    var ogLiveSize:Float = 0;
    
    /**
     * how big the portrait is supposed to be
     */
    var ogPortraitSize:Float = 0;
    
    /**
     * where the cursor should be
     */
    var ogPortraitPos:Float = 0;
    
    /**
     * the tween used to scale the portraits to the beat
     */
    var portratScaleTween:FlxTween;

    /**
     * the tween used to scale the lives to the beat
     */
    var liveScaleTweens:Array<FlxTween> = [];
        
    var namePlateTween:FlxTween;

    var lifecount:Int = 4;
    
    public function new():Void{
        super();
        
        portrait = new FlxSprite();
        portrait.frames = FlxAtlasFrames.fromSparrow('assets/images/avatarportraits/' + PlayState.curAvatar + '.png', 'assets/images/avatarportraits/' + PlayState.curAvatar + '.xml');
        if(PlayState.curAvatar == 'illbert' || PlayState.curAvatar == 'illbertlocked'){
            portrait.animation.addByPrefix('hp1', 'hp1', 1);
            portrait.animation.addByPrefix('hp0', 'hp1', 1);
            portrait.animation.play('hp1');   
        } else {            
            portrait.animation.addByPrefix('hp4', 'hp4', 1);
            
            portrait.animation.addByPrefix('hp3', 'hp3', 1);
            portrait.animation.addByPrefix('hp2', 'hp2', 1);
            portrait.animation.addByPrefix('hp1', 'hp1', 1);
            portrait.animation.addByPrefix('hp0', 'hp1', 1);
            if(PlayState.curAvatar == 'trifecta') portrait.animation.addByPrefix('hp5', 'hp5', 1);
            portrait.animation.play('hp4');   
        }
        portrait.setGraphicSize(Std.int(portrait.width * .2));
        portrait.updateHitbox();
        ogPortraitSize = portrait.scale.x;
        portrait.screenCenter(X);
        portrait.y = PlayState.scoreBgHeight - portrait.height;
        add(portrait);
        
        for(i in 0...PlayState.maxLives){
            var lifeIcon = new FlxSprite();
            lifeIcon.frames = FlxAtlasFrames.fromSparrow('assets/images/lives/' + PlayState.curAvatar + '.png', 'assets/images/lives/' + PlayState.curAvatar + '.xml');
            lifeIcon.animation.addByPrefix('good', 'good', 1);
            lifeIcon.animation.addByPrefix('bad', 'bad', 1);
            lifeIcon.animation.play('good');
            lifeIcon.setGraphicSize(Std.int(lifeIcon.width * .1));
            lifeIcon.updateHitbox();
            lifeIcon.screenCenter(X);
            ogLiveSize = lifeIcon.scale.x;
            Utilities.centerSpriteOnSprite(lifeIcon, portrait, false, true);
            add(lifeIcon);
            lives.push(lifeIcon);
        }
        
        Utilities.centerGroup(null, lives, PlayState.curAvatar == 'trifecta' ? 15 : 20);
        
        portrait.x -= 200;
        
        ogPortraitPos = portrait.x + portrait.width / 2;

        var iterator = 1;
        
        for(i in lives){
            i.x += PlayState.curAvatar == 'trifecta' ? 80 : 100;
            
            
            i.ID = iterator;
            
            iterator ++;
        }
        
        namePlate = new FlxSprite().loadGraphic('assets/images/nameplates/'+ PlayState.curAvatar  + '.png');
        namePlate.setGraphicSize(Std.int(namePlate.width * .6));
        namePlate.updateHitbox();
        namePlate.y = 15;
        namePlate.x = (FlxG.width - namePlate.width) - 62;
        add(namePlate);
        
        addScore();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        updatePortraitPos();
    }
    
    function updatePortraitPos():Void{
        portrait.updateHitbox();
        portrait.y = PlayState.scoreBgHeight - portrait.height;
        Utilities.centerSpriteOnPos(portrait, ogPortraitPos);
    }
    
    /**
     * call this when a beat is hit
     * @param curBeat which beat the song is on
     */
    public function beatHit(curBeat:Int):Void{ 
        for(i in liveScaleTweens){
            if(i != null && i.active){
                i.cancel();
                i.destroy();
            }
        }   
        
        var scaleAdditive:Float = 1.2;
        var scaleSubtractive:Float = .8;
        
        switch(lifecount){
            case 3:
                scaleAdditive = 1.3;
                scaleSubtractive = .7;
            case 2:
                scaleAdditive = 1.4;
                scaleSubtractive = .6;
            case 1:
                scaleAdditive = 1.5;
                scaleSubtractive = .5;
        }
        
        liveScaleTweens = [];
        
        for(i in lives){
            if(i.animation.curAnim.name == 'good'){
                i.scale.set(ogLiveSize * scaleAdditive, ogLiveSize * scaleAdditive);
                liveScaleTweens.push(FlxTween.tween(i.scale, {x: ogLiveSize, y:ogLiveSize}, 1, {ease: FlxEase.quartOut}));     
            }          
        }
        
        if(portratScaleTween != null && portratScaleTween.active){
            portratScaleTween.cancel();
            portratScaleTween.destroy();
        }
        
        portrait.scale.set(ogPortraitSize * scaleAdditive, ogPortraitSize * scaleSubtractive);
        portratScaleTween = FlxTween.tween(portrait.scale, {x: ogPortraitSize, y:ogPortraitSize}, 1, {ease: FlxEase.quartOut});   
        
        updatePortraitPos();
        
        if(namePlateTween != null && namePlateTween.active){
            namePlateTween.cancel();
            namePlateTween.destroy();
        }
        
        namePlate.angle = (curBeat % 2 == 0 ? (-10 * scaleAdditive) : (10 * scaleAdditive));
        namePlateTween = FlxTween.tween(namePlate, {angle: 0}, 1, {ease: FlxEase.quartOut});   
    }
    
    /**
     * call this to update how many lives are being tracked
     * @param lifecount how many
     */
    public function updateLives(lifecount:Int):Void{
        this.lifecount = lifecount;
        
        for(i in lives){
            if(i.ID > lifecount) {
                i.animation.play('bad'); 
                i.scale.set(ogLiveSize, ogLiveSize);
                FlxTween.cancelTweensOf(i);
            } else { 
                i.animation.play('good'); 
            }
        }
         
        portrait.animation.play('hp' + lifecount);
        
        if(lifecount == 0){ //dont do tjhat anymore
            for(i in scorePosTweens){
                if(i != null){
                    i.cancel();
                    i.destroy();
                }    
            }
            
            scorePosTweens = [];
        }
    }
        
    public var scoreSprites:Array<FlxSprite> = [];
    var scoreSizeTweens:Array<FlxTween> = [];
    var scorePosTweens:Array<FlxTween> = [];
    
    public function addScore():Void{        
        for(i in scoreSprites){
            i.destroy();
        }
        
        scoreSprites = [];
        
        for(i in scoreSizeTweens){
            if(i != null){
                i.cancel();
                i.destroy();
            }    
        }
        
        scoreSizeTweens = [];
        
        for(i in scorePosTweens){
            if(i != null){
                i.cancel();
                i.destroy();
            }    
        }
        
        scorePosTweens = [];
        
        var wordArray = Utilities.stringToArray(Std.string(PlayState.curScore));
        
        var iterator:Int = 0;
        
        for(i in wordArray){
            var spr = new FlxSprite().loadGraphic('assets/images/scoresprites/' + i + '.png');
            spr.y = 30;
            spr.antialiasing = true;
            add(spr);
            scoreSprites.push(spr);
            
            if(PlayState.curScore > 0){
                var scaleAdditive:Float = 1.4;
                
                switch(lifecount){
                    case 3:
                        scaleAdditive = 1.5;
                    case 2:
                        scaleAdditive = 1.6;
                    case 1:
                        scaleAdditive = 1.7;
                }
                
                spr.scale.set(scaleAdditive, scaleAdditive);
                scorePosTweens.push(FlxTween.tween(spr.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quartOut}));      
            }
            
            var ytweenmovement:Int = 10;
                
            spr.y -= ytweenmovement;
            scorePosTweens.push(FlxTween.tween(spr, {y: spr.y + ytweenmovement}, 1, {startDelay: 2 * (iterator / wordArray.length), ease: FlxEase.smootherStepInOut, type: PINGPONG}));
            
            iterator++;
        }
        
        Utilities.centerGroup(null, scoreSprites, 10, 190);
    }
    
    override function destroy():Void{
        lives = [];
        liveScaleTweens = [];
        
        super.destroy();
    }
}