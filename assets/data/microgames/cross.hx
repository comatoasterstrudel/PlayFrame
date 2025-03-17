var bg:FlxSprite;
var ground:FlxSprite;
var loooogi:FlxSprite;
var door:FlxSprite;

var hitboxes:Array<FlxSprite> = [];
var playerhitbox:FlxSprite;
var doorhitbox:FlxSprite;

var speed:Float = 250;

var allowControl:Bool = true;

var endingCutscene:Bool = false;

var cutsceneTimers:Array<FlxTimer> = [];
var cutsceneTweens:Array<FlxTimer> = [];

var logsquishtween:FlxTween;

var grounded:Bool = true;

var previousX:Int = 1;

var fell:Bool = false;

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
    
    door = new FlxSprite();
    door.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/cross/door.png', 'assets/images/microgames/cross/door.xml');
    door.animation.addByPrefix('open', 'open', 1); //lies
    door.animation.addByPrefix('closed', 'closed', 1); //lies
    door.animation.play('closed');
    Utilities.centerSpriteOnPos(door, frameWidth / 2, frameHeight / 2);
    door.y += 60;
    microgameGroup.add(door);
        
    loooogi = new FlxSprite();
    loooogi.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/cross/loooogi.png', 'assets/images/microgames/cross/loooogi.xml');
    loooogi.animation.addByPrefix('front', 'front', 1);
    loooogi.animation.addByPrefix('back', 'back', 1);
    loooogi.animation.play('front');
    Utilities.centerSpriteOnPos(loooogi, frameWidth / 2, frameHeight / 2);
    loooogi.x = 25;
    loooogi.y += -5;
    microgameGroup.add(loooogi);
    
    frameCamera.follow(loooogi, FlxCameraFollowStyle.TOPDOWN, 0.07);
    frameCamera.setScrollBoundsRect(ground.x, 0, ground.x + ground.width, frameHeight * 1.1, true);
    
    var hitbox1 = new FlxSprite().makeGraphic(400, 4000, 0xFFFF0000);
    hitbox1.setPosition(-80, 345);
    hitbox1.immovable = true;
    hitbox1.visible = false;
    microgameGroup.add(hitbox1);
    
    var hitbox2 = new FlxSprite().makeGraphic(350, 4000, 0xFFFF0000);
    hitbox2.setPosition(frameWidth - hitbox2.width, 345);
    hitbox2.immovable = true;
    hitbox2.visible = false;
    microgameGroup.add(hitbox2);
        
    hitboxes = [hitbox1, hitbox2];
    
    doorhitbox = new FlxSprite().makeGraphic(100, 200, 0xffff0099);
    Utilities.centerSpriteOnSprite(doorhitbox, door, true, true);
    doorhitbox.y -= 100;
    doorhitbox.x += 288;
    doorhitbox.visible = false;
    microgameGroup.add(doorhitbox);
    
    playerhitbox = new FlxSprite().makeGraphic(60, 80, 0xFF00ff00);
    Utilities.centerSpriteOnSprite(playerhitbox, loooogi, true, true);
    playerhitbox.y += 50;
    playerhitbox.acceleration.y = 400 * PlayState.additiveSpeed;
    playerhitbox.visible = false;
    microgameGroup.add(playerhitbox);
    
    previousX = playerhitbox.x;
}

function update(elapsed:Float){        
    playerhitbox.velocity.x = 0;
    
    if(allowControl){
        if(Controls.getControl('RIGHT', 'HOLD')){
            loooogi.flipX = false;
            playerhitbox.velocity.x = (speed * PlayState.additiveSpeed);
        }
        
        if(Controls.getControl('LEFT', 'HOLD')){
            loooogi.flipX = true;
    
            playerhitbox.velocity.x = (-speed * PlayState.additiveSpeed);
        }   
    }
         
    for(i in hitboxes){
        FlxG.collide(i, playerhitbox);
    }   
    
    if(allowControl){
        if(Controls.getControl('UP', 'RELEASE') && playerhitbox.isTouching(0x1000)){
            squishLog(false);
            playerhitbox.velocity.y = -300;
        }
        
        if(FlxG.overlap(playerhitbox, doorhitbox) && playerhitbox.isTouching(0x1000)){
            //win
            win();   
        }
    }
    
    if(endingCutscene){
        playerhitbox.x = Utilities.lerpThing(playerhitbox.x, doorhitbox.x + doorhitbox.width / 2 - playerhitbox.width / 2, elapsed, 4 * PlayState.additiveSpeed);    
    }
    
    if(!grounded && playerhitbox.isTouching(0x1000)){
        squishLog(true); //just landed
    }
    
    if(playerhitbox.x < -60 || playerhitbox.x > 850) playerhitbox.x = previousX;
    
    previousX = playerhitbox.x;

    grounded = playerhitbox.isTouching(0x1000);
    
    loooogi.updateHitbox();
    Utilities.centerSpriteOnSprite(loooogi, playerhitbox, true, true);
    loooogi.y = playerhitbox.y + playerhitbox.height - loooogi.height;
    //loooogi.y -= 50;
    
    if(!fell && loooogi.y > 400){
        fall();
    } 
}

function win():Void{
    PlayState.wonMicrogame = true;
    allowControl = false;
    
    endingCutscene = true;

    loooogi.animation.play('back');  
    
    squishLog(true);

    cutsceneTimers.push(new FlxTimer().start(1 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
	{
		door.animation.play('open');
        cutsceneTweens.push(FlxTween.shake(door, 0.01, .2 * PlayState.subtractiveSpeed, 0x01));
        
        cutsceneTweens.push(FlxTween.tween(loooogi, {alpha: 0}, 1 * PlayState.subtractiveSpeed, {startDelay: .5 * PlayState.subtractiveSpeed, ease: FlxEase.quartOut}));   
        
        cutsceneTimers.push(new FlxTimer().start(1.5 * PlayState.subtractiveSpeed, function(tmr:FlxTimer)
        {
            cutsceneTweens.push(FlxTween.shake(door, 0.01, .2 * PlayState.subtractiveSpeed, 0x01));
            door.animation.play('closed');
        }));
	}));
}

function fall():Void{
    fell = true;
}

function squishLog(x:Bool):Void{
    if(logsquishtween != null && logsquishtween.active){
        logsquishtween.cancel();
        logsquishtween.destroy();
    }    
    
    if(!x){
        loooogi.scale.set(.7, 1.3);
    } else {
        loooogi.scale.set(1.3, .7);
    }
    
    logsquishtween = (FlxTween.tween(loooogi.scale, {x: 1, y: 1}, .6 * PlayState.subtractiveSpeed, {ease: FlxEase.quartOut}));   
}

function endMicrogame():Void{ 
    allowControl = false;
}

function destroyMicrogame():Void{
    bg.destroy();
    ground.destroy();
    door.destroy();
    loooogi.destroy();
    
    for(i in hitboxes){
        i.destroy();
    }
    playerhitbox.destroy();
    doorhitbox.destroy();
    
    for(i in cutsceneTimers){
        if(i != null && i.active){
            i.cancel();
            i.destroy();
        }
    }
    
    for(i in cutsceneTweens){
        if(i != null && i.active){
            i.cancel();
            i.destroy();
        }
    }
}