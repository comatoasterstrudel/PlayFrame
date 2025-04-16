package playframe.menu.main;

class MainMenuButton extends FlxSprite
{
    public var targetX:Float = 1;
	public var targetScaleX:Float = 1;
	public var targetScaleY:Float = 1;
    public var targetAlpha:Float = 1;
    
    public function new(name:String):Void{
        super(); 
        
        loadGraphic('assets/images/menu/buttons/' + name + '.png');
    }

    override function update(elapsed:Float){
        super.update(elapsed);

		scale.x = Utilities.lerpThing(scale.x, targetScaleX, elapsed, 4);
		scale.y = Utilities.lerpThing(scale.y, targetScaleY, elapsed, 4);

        updateHitbox();

        alpha = Utilities.lerpThing(alpha, targetAlpha, elapsed, 4);
        
		x = Utilities.lerpThing(x, (targetX * FlxG.width / 4) + FlxG.width / 2 - width / 2, elapsed, 5);
		y = FlxG.height - height * 1;
    }
}