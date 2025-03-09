package playframe.menu;

class CharacterSelectSprite extends FlxSprite
{
    public var targetX:Float = 1;
	public var targetScale:Float = 1;

    public function new(name:String):Void{
        super(); 

        frames = FlxAtlasFrames.fromSparrow('assets/images/avatarportraits/' + name + '.png', 'assets/images/avatarportraits/' + name + '.xml');
        animation.addByPrefix('hp4', 'hp4', 1);
        animation.play('hp4');
        setGraphicSize(Std.int(width * .5));
        updateHitbox();
        screenCenter(X);
        y = FlxG.height - height;
        
        var data = new AvatarData(name);
		
		color = data.color;
    }

    override function update(elapsed:Float){
        super.update(elapsed);

		scale.x = Utilities.lerpThing(scale.x, targetScale, elapsed, 15);
		scale.y = Utilities.lerpThing(scale.y, targetScale, elapsed, 15);

        updateHitbox();
        
		x = Utilities.lerpThing(x, (targetX * FlxG.width / 3) + FlxG.width / 2 - width / 2, elapsed, 10.2);
		y = FlxG.height - height;
    }
}