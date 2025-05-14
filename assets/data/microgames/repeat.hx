var bg:FlxSprite;

function create(){
    PlayState.wonMicrogame = false;

    bg = new FlxSprite().loadGraphic('assets/images/microgames/repeat/bg.png');
    Utilities.centerSpriteOnPos(bg, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(bg);
}

function update(elapsed:Float){

}

function endMicrogame():Void{

}

function destroyMicrogame():Void{
    bg.destroy();
}