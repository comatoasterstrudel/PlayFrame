package playframe.menu.config;

class CharacterSelectSprite extends FlxSprite
{
    public var targetX:Float = 1;
	public var targetScale:Float = 1;

    public var targetScaleX:Float = 0;
    public var targetScaleY:Float = 0;
    
    public var followTarget:Bool = true;
    
    public function new(name:String):Void{
        super(); 

        frames = FlxAtlasFrames.fromSparrow('assets/images/avatarportraits/' + name + '.png', 'assets/images/avatarportraits/' + name + '.xml');
        if(name == 'illbert' || name =='illbertlocked'){
            animation.addByPrefix('hp1', 'hp1', 1);
            animation.play('hp1');   
        } else {
            animation.addByPrefix('hp4', 'hp4', 1);
            animation.play('hp4');   
        }
        setGraphicSize(Std.int(width * .5));
        updateHitbox();
        screenCenter(X);
        y = FlxG.height - height;
        
        var data = new AvatarData(name);
		
		color = data.color;
    }

    override function update(elapsed:Float){
        super.update(elapsed);

        if(targetScaleX == 0 && targetScaleY == 0){            
            scale.x = Utilities.lerpThing(scale.x, targetScale, elapsed, 15);
            scale.y = Utilities.lerpThing(scale.y, targetScale, elapsed, 15);   
        } else {
            scale.x = Utilities.lerpThing(scale.x, targetScaleX, elapsed, 15);
            scale.y = Utilities.lerpThing(scale.y, targetScaleY, elapsed, 15);
        }

        updateHitbox();

        x = Utilities.lerpThing(x, (targetX * FlxG.width / 3) + FlxG.width / 2 - width / 2, elapsed, 10.2);

        if(followTarget){
            y = FlxG.height - height;            
        }
    }
}