var bg:FlxSprite;
var bridge:FlxSprite;

var pickshape:FlxSprite;
var friend:FlxSprite;

var heldshape:FlxSprite;

var canControl:Bool = true;

var speed:Float = 300;

var holding:Bool = false;

var dropped:Bool = false;

var well1:FlxSprite;
var hole1:FlxSprite;
var holebox1:FlxSprite;
var fakewell1:FlxSprite;

var well2:FlxSprite;
var hole2:FlxSprite;
var holebox2:FlxSprite;
var fakewell2:FlxSprite;

var well3:FlxSprite;
var hole3:FlxSprite;
var holebox3:FlxSprite;
var fakewell3:FlxSprite;

var coverup:FlxSprite;
var fakecoverup:FlxSprite;

var droppedBox1:Bool = false;
var droppedBox2:Bool = false;
var droppedBox3:Bool = false;

var ended:Bool = false;

var selectedshape:Int = 1; // 1 = pentagon, 2 = circle, 3 = hell

function create():Void{
    PlayState.wonMicrogame = false;
    
    selectedshape = FlxG.random.int(1,3);
    
    bg = new FlxSprite().loadGraphic('assets/images/microgames/drop/bg_cave.png');
    bg.scale.set(1.2, 1.2);
    bg.updateHitbox();
    Utilities.centerSpriteOnPos(bg, frameWidth / 2, frameHeight / 2);
    bg.y += 10;
    microgameGroup.add(bg);
    
    bridge = new FlxSprite().loadGraphic('assets/images/microgames/drop/bg_bridge.png');
    Utilities.centerSpriteOnPos(bridge, frameWidth / 2, frameHeight / 2);
    bridge.y -= 60;
    microgameGroup.add(bridge);
    
    formWells();

    friend = new FlxSprite();
    friend.frames = FlxAtlasFrames.fromSparrow('assets/images/microgames/drop/friend insideme.png', 'assets/images/microgames/drop/friend insideme.xml');
    friend.scale.set(.35, .35);
    friend.updateHitbox();
    friend.animation.addByPrefix('idle', 'idle', 2 * PlayState.additiveSpeed);
    friend.animation.addByPrefix('drop', 'drop', 7 * PlayState.additiveSpeed, false);
    friend.animation.addByPrefix('hold', 'hold', 2 * PlayState.additiveSpeed);
    friend.animation.addByPrefix('holdwalk', 'b_holdwalk', 2 * PlayState.additiveSpeed);
    friend.animation.addByPrefix('run', 'run', 4 * PlayState.additiveSpeed);
    friend.animation.addByPrefix('win', 'win', 10 * PlayState.additiveSpeed, false);
    Utilities.centerSpriteOnPos(friend, frameWidth / 2, frameHeight / 2);
    friend.y -= 130;
    microgameGroup.add(friend);
        
    friend.animation.play('idle');
    
    heldshape = new FlxSprite().loadGraphic('assets/images/microgames/drop/shape' + selectedshape + '.png');
    microgameGroup.add(heldshape);
    
    pickshape = new FlxSprite().loadGraphic('assets/images/microgames/drop/shape' + selectedshape + '.png');
    pickshape.scale.set(1, 1);
    Utilities.centerSpriteOnPos(pickshape, frameWidth / 2, frameHeight / 2);
    pickshape.y -= 130;
    if(FlxG.random.bool(50)){
        pickshape.x += 300;
    } else {
        pickshape.x -= 300;
        friend.flipX = true;
    }
    microgameGroup.add(pickshape);
    
    FlxTween.tween(pickshape.scale, {x: 1.35, y: 1.35}, 1, {ease: FlxEase.smootherStepInOut, type: PINGPONG});    
    
    coverup = new FlxSprite().loadGraphic('assets/images/microgames/drop/bottombottom.png');
    coverup.screenCenter();
    coverup.y = frameHeight - 50;
    microgameGroup.add(coverup);
}

function formWells():Void{
    hole1 = new FlxSprite().loadGraphic('assets/images/microgames/drop/hole_1.png');
    Utilities.centerSpriteOnPos(hole1, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(hole1);
    
    well1 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_1.png');
    Utilities.centerSpriteOnPos(well1, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(well1);
    
    holebox1 = new FlxSprite().makeGraphic(70, 100, 0xFFEE0202);
    Utilities.centerSpriteOnPos(holebox1, frameWidth / 2, frameHeight / 2);
    holebox1.y = frameHeight - 100;
    holebox1.x -= 270;
    holebox1.visible = false;
    microgameGroup.add(holebox1);
    
    hole2 = new FlxSprite().loadGraphic('assets/images/microgames/drop/hole_2.png');
    Utilities.centerSpriteOnPos(hole2, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(hole2);
    
    well2 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_2.png');
    Utilities.centerSpriteOnPos(well2, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(well2);
    
    holebox2 = new FlxSprite().makeGraphic(70, 100, 0xFFEE0202);
    Utilities.centerSpriteOnPos(holebox2, frameWidth / 2, frameHeight / 2);
    holebox2.y = frameHeight - 100;
    holebox2.visible = false;
    microgameGroup.add(holebox2);
    
    hole3 = new FlxSprite().loadGraphic('assets/images/microgames/drop/hole_3.png');
    Utilities.centerSpriteOnPos(hole3, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(hole3);
    
    well3 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_3.png');
    Utilities.centerSpriteOnPos(well3, frameWidth / 2, frameHeight / 2);
    microgameGroup.add(well3);
    
    holebox3 = new FlxSprite().makeGraphic(90, 100, 0xFFEE0202);
    Utilities.centerSpriteOnPos(holebox3, frameWidth / 2, frameHeight / 2);
    holebox3.y = frameHeight - 85;
    holebox3.x += 290;
    holebox3.visible = false;
    microgameGroup.add(holebox3);
}

function update(elapsed:Float):Void{
    friend.velocity.x = 0;

    if(canControl){
        if(holding){
            speed = 250;    
        } else {
            speed = 300;
        }
        
        if(Controls.getControl('LEFT', 'HOLD') && !checkLeftBoundary()){            
            friend.velocity.x = -(speed * PlayState.additiveSpeed);
            friend.flipX = true;
            if(holding) friend.animation.play('holdwalk', false); else friend.animation.play('run', false);
        } else if(Controls.getControl('RIGHT', 'HOLD') && !checkRightBoundary()){
            friend.velocity.x = (speed * PlayState.additiveSpeed);
            friend.flipX = false;
            if(holding) friend.animation.play('holdwalk', false); else friend.animation.play('run', false);
        } else {
            if(holding) friend.animation.play('hold', false); else friend.animation.play('idle', false);
        }
        
        if(holding){
            if(Controls.getControl('DOWN', 'RELEASE') || Controls.getControl('ACCEPT', 'RELEASE')){            
                dropShape();
            }
        } else {
            if(Controls.getControl('UP', 'RELEASE') && FlxG.overlap(friend, pickshape)|| Controls.getControl('ACCEPT', 'RELEASE') && FlxG.overlap(friend, pickshape)){            
               holding = true;
               pickshape.visible = false;
            }
        }
    } else {
        if(dropped){
            //friend.animation.play('idle', false);
        } 
    }
    
    switch(friend.animation.curAnim.name){
        case 'idle':
            friend.y = 0;
        case 'run':
            friend.y = -15;
        case 'hold':
            friend.y = 0;
        case 'holdwalk':
            friend.y = 0;  
    }
    
    if(holding ||dropped){
        heldshape.visible = true;
        if(!dropped){
            Utilities.centerSpriteOnSprite(heldshape, friend, true, true);
            heldshape.y += 25;
            
            if(friend.flipX){
                heldshape.x -= 20;
            } else {
                heldshape.x += 20;
            }   
        }
    } else {
        heldshape.visible = false;
    }
    
    if(!ended){
        if(heldshape.y > frameHeight - 50){
            if(droppedBox1 && selectedshape == 1 || droppedBox2 && selectedshape == 2 || droppedBox3 && selectedshape == 3){
                win();
            }
        } else if(heldshape.y > frameheight){
           lose();
        }
    }
}

function checkLeftBoundary():Bool{
    return(friend.x < -70);
}

function checkRightBoundary():Bool{
    return (friend.x + friend.width > frameWidth + 70);
}

function dropShape():Void{
    dropped = true;
    canControl = false;
    
    friend.animation.play('drop');
    
    heldshape.acceleration.y = 900 * (PlayState.additiveSpeed * 1.5);
    
    var tempHitbox = new FlxSprite().makeGraphic(heldshape.width, frameHeight, 0xFF650EE6);
    tempHitbox.x = heldshape.x;
    tempHitbox.visible = false;
    microgameGroup.add(tempHitbox);
    
    if(FlxG.overlap(tempHitbox, holebox1)){
        trace('box1');
        
        fakewell1 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_1.png');
        Utilities.centerSpriteOnPos(fakewell1, frameWidth / 2, frameHeight / 2);
        microgameGroup.add(fakewell1);
        
        droppedBox1 = true;
    }
    
    if(FlxG.overlap(tempHitbox, holebox2)){
        trace('box2');
        
        fakewell2 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_2.png');
        Utilities.centerSpriteOnPos(fakewell2, frameWidth / 2, frameHeight / 2);
        microgameGroup.add(fakewell2);
        
        droppedBox2 = true;
    }
    
    if(FlxG.overlap(tempHitbox, holebox3)){
        trace('box3');
        
        fakewell3 = new FlxSprite().loadGraphic('assets/images/microgames/drop/well_3.png');
        Utilities.centerSpriteOnPos(fakewell3, frameWidth / 2, frameHeight / 2);
        microgameGroup.add(fakewell3);
        
        droppedBox3 = true;
    }
    
    fakecoverup = new FlxSprite().loadGraphic('assets/images/microgames/drop/bottombottom.png');
    fakecoverup.screenCenter();
    fakecoverup.y = frameHeight - 50;
    microgameGroup.add(fakecoverup);
    
    coverup.visible = false;
}

function win():Void{
    ended = true;
    
    PlayState.wonMicrogame = true;
    
    friend.animation.play('win');
}

function lose():Void{
    
}

function endMicrogame():Void{
    canControl = false;
    
    ended = true;
}

function destroyMicrogame():Void{
    bg.destroy();
    bridge.destroy(); 
    
    friend.destroy();
    
    pickshape.destroy();
    heldshape.destroy();
    
    well1.destroy();
    well2.destroy();
    well3.destroy();
    hole1.destroy();
    hole2.destroy();
    hole3.destroy();
    holebox1.destroy();
    holebox2.destroy();
    holebox3.destroy();
    if(fakewell1 != null) fakewell1.destroy();
    if(fakewell2 != null) fakewell2.destroy();
    if(fakewell3 != null) fakewell3.destroy();
    
    coverup.destroy();
    if(fakecoverup != null) fakecoverup.destroy();
}
