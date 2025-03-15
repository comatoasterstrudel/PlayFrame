var bg:FlxSprite;
var ground:FlxSprite;
var loooogi:FlxSprite;

var hitboxes:Array<FlxSprite> = [];
var playerhitbox:FlxSprite;

var speed:Float = 400;

function create(){
    PlayState.wonMicrogame = false;
    
    bg = new FlxSprite().makeGraphic(frameWidth, frameHeight, 0xFF7AEDFF);
    bg.scrollFactor.set(0,0);
    microgameGroup.add(bg);
    
    ground = new FlxSprite().loadGraphic('assets/images/microgames/cross/ground.png');
    ground.scale.x = 1.15;
    ground.updateHitbox();
    Utilities.centerSpriteOnPos(ground, frameWidth / 2, frameHeight / 2);
    ground.y += 60;
    microgameGroup.add(ground);
    
    loooogi = new FlxSprite();
    loooogi.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/cross/loooogi.png', 'assets/images/microgames/cross/loooogi.xml');
    loooogi.animation.addByPrefix('front', 'front', 1);
    loooogi.animation.addByPrefix('back', 'back', 1);
    loooogi.animation.play('front');
    Utilities.centerSpriteOnPos(loooogi, frameWidth / 2, frameHeight / 2);
    loooogi.x = 25;
    loooogi.y -= 50;
    microgameGroup.add(loooogi);
    
    frameCamera.follow(loooogi, FlxCameraFollowStyle.TOPDOWN, 0.07);
    frameCamera.setScrollBoundsRect(ground.x, 0, ground.x + ground.width, frameHeight * 1.1, true);
    
    var hitbox1 = new FlxSprite().makeGraphic(400, 180, 0xFFFF0000);
    hitbox1.setPosition(-80, frameHeight -  hitbox1.height);
    hitbox1.immovable = true;
    microgameGroup.add(hitbox1);
    
    var hitbox2 = new FlxSprite().makeGraphic(350, 180, 0xFFFF0000);
    hitbox2.setPosition(frameWidth - hitbox2.width, frameHeight -  hitbox2.height);
    hitbox2.immovable = true;
    microgameGroup.add(hitbox2);
    
    hitboxes = [hitbox1, hitbox2];
    
    playerhitbox = new FlxSprite().makeGraphic(60, 80, 0xFF00ff00);
    Utilities.centerSpriteOnSprite(playerhitbox, loooogi, true, true);
    playerhitbox.y += 50;
    playerhitbox.acceleration.y = 200 * PlayState.additiveSpeed;
    microgameGroup.add(playerhitbox);
    
    trace('lol');
}

function update(elapsed:Float){
    //frameCamera.scroll.x += (5 * elapsed);    
    
    Utilities.centerSpriteOnSprite(loooogi, playerhitbox, true, true);
    loooogi.y -= 50;

    playerhitbox.velocity.x = 0;
    
    if(Controls.getControl('RIGHT', 'HOLD')){
        playerhitbox.velocity.x = (speed * PlayState.additiveSpeed);
    }
    
    if(Controls.getControl('LEFT', 'HOLD')){
        playerhitbox.velocity.x = (-speed * PlayState.additiveSpeed);
    }
        
    if(Controls.getControl('UP', 'RELEASE') && playerhitbox.isTouching(0x1000)){
        trace('??????/');
        playerhitbox.velocity.y = -500;
    }
    
    //if((playerhitbox.x + playerhitbox.width / 2) < 0 && playerhitbox.velocity.x < 0){ //dont move to the left smh
    //    playerhitbox.velocity.x = 0;
    //}
    
    trace('fuck you');
    for(i in hitboxes){
        FlxG.collide(i, playerhitbox);
        trace('fuck you2');
    }    
}

function endMicrogame():Void{ 

}

function destroyMicrogame():Void{
    bg.destroy();
    ground.destroy();
    loooogi.destroy();
    
    for(i in hitboxes){
        i.destroy();
    }
    playerhitbox.destroy();
}