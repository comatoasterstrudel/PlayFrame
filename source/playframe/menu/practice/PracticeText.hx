package playframe.menu.practice;

class PracticeText extends FlxText
{
	public var targetY:Float = 0;
    public var targetX:Float = 0;

	public function new(x:Float, y:Float, name:String)
	{
		super(x, y);
		targetX = x;
        targetY = y;
		text = name;
	}

	override function update(elapsed:Float)
	{
		x = Utilities.lerpThing(x, targetX, elapsed, 5);
		y = Utilities.lerpThing(y, (targetY * 120) + FlxG.height / 2 - height / 2, elapsed, 5);

		super.update(elapsed);
	}	
}