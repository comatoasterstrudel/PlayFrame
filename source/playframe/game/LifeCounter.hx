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

    public function new():Void{
        super();
        
        portrait = new FlxSprite();
        portrait.frames = FlxAtlasFrames.fromSparrow('assets/images/avatarportraits/' + PlayState.curAvatar + '.png', 'assets/images/avatarportraits/' + PlayState.curAvatar + '.xml');
        portrait.animation.addByPrefix('hp4', 'hp4', 1);
        portrait.animation.addByPrefix('hp3', 'hp3', 1);
        portrait.animation.addByPrefix('hp2', 'hp2', 1);
        portrait.animation.addByPrefix('hp1', 'hp1', 1);
        portrait.animation.play('hp4');
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
        
        Utilities.centerGroup(null, lives, 20);
        
        portrait.x -= 200;
        
        ogPortraitPos = portrait.x + portrait.width / 2;

        for(i in lives){
            i.x += 100;
        }
        
        namePlate = new FlxSprite().loadGraphic('assets/images/nameplates/'+ PlayState.curAvatar  + '.png');
        namePlate.setGraphicSize(Std.int(namePlate.width * .6));
        namePlate.updateHitbox();
        namePlate.y = 15;
        namePlate.x = (FlxG.width - namePlate.width) - 62;
        add(namePlate);
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
        
        liveScaleTweens = [];
        
        for(i in lives){
            i.scale.set(ogLiveSize * 1.2, ogLiveSize * 1.2);
            liveScaleTweens.push(FlxTween.tween(i.scale, {x: ogLiveSize, y:ogLiveSize}, 1, {ease: FlxEase.quartOut}));            
        }
        
        if(portratScaleTween != null && portratScaleTween.active){
            portratScaleTween.cancel();
            portratScaleTween.destroy();
        }
        
        portrait.scale.set(ogPortraitSize * 1.2, ogPortraitSize * .8);
        portratScaleTween = FlxTween.tween(portrait.scale, {x: ogPortraitSize, y:ogPortraitSize}, 1, {ease: FlxEase.quartOut});   
        
        updatePortraitPos();
        
        if(namePlateTween != null && namePlateTween.active){
            namePlateTween.cancel();
            namePlateTween.destroy();
        }
        
        namePlate.angle = (curBeat % 2 == 0 ? -10 : 10);
        namePlateTween = FlxTween.tween(namePlate, {angle: 0}, 1, {ease: FlxEase.quartOut});   
    }
    
    override function destroy():Void{
        lives = [];
        liveScaleTweens = [];
        
        super.destroy();
    }
}