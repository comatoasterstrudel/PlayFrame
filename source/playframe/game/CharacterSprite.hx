package playframe.game;

class CharacterSprite extends FlxSprite
{
    var snapY:Bool = false;
    
    var ogScale:Float = 1;
    
    var ogY:Float = 0;
    var ogX:Float = 1;
    
    public function new(name:String):Void{
        super(); 

        frames = FlxAtlasFrames.fromSparrow('assets/images/charsprites/' + name + '.png', 'assets/images/charsprites/' + name + '.xml');
        animation.addByPrefix('intro', 'intro', 3 * PlayState.additiveSpeed);
        animation.addByPrefix('normal', 'intro', 3 * PlayState.additiveSpeed);
        animation.addByPrefix('win', 'win', 3 * PlayState.additiveSpeed);
        animation.addByPrefix('lose', 'lose', 3 * PlayState.additiveSpeed);
        animation.addByPrefix('scared', 'scared', 3 * PlayState.additiveSpeed);
        setGraphicSize(Std.int(width * .63));
        
        updateHitbox();
        
        ogScale = scale.x;        
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(snapY){
            updateHitbox();
            y = ogY - height;
            Utilities.centerSpriteOnPos(this, ogX);
        }
    }
    
    public function playAnim(name:String, playanim = false):Void{
        animation.play(name);
        
        if(playanim){
            snapY = true;
            ogY = y + height;
            ogX = x + width / 2;
              
            scale.set(ogScale * 1.1, ogScale * .9);
            FlxTween.tween(scale, {x: ogScale, y: ogScale}, 1 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut});   
        }
    }
    
    public function updateFps():Void{
        if(animation.curAnim != null){
            if(animation.curAnim.name == 'die') return;
        }
        for(i in animation.getAnimationList()){
            i.frameRate = 3 * PlayState.additiveSpeed;
        }
        if(animation.curAnim != null){
            animation.play(animation.curAnim.name, false);            
        }
    }
}