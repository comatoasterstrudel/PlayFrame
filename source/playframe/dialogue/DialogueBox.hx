package playframe.dialogue;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DialogueBox extends FlxTypedGroup<FlxSprite>
{
    var dialoguebox:FlxSprite;
    var dialogueboxoutline:FlxSprite;
    var dialogueboxdeco:FlxSprite;

    var dialoguetext:FlxTypeText;

    var shouldbevisible:Bool = false;

    var controlallowed:Bool = false;

    var endfunc:Void->Void;
    var startfunc:Void->Void;

    var finishedtyping:Bool = false;

    var diaheight:Float = 1000;

    public function new():Void{
        super();

        dialoguebox = new FlxSprite();
        dialoguebox.frames = FlxAtlasFrames.fromSparrow('assets/images/dia/diaboxback.png', 'assets/images/dia/diaboxback.xml');
        dialoguebox.animation.addByPrefix('idle', 'idle', 3);
        dialoguebox.animation.play('idle');
        dialoguebox.scale.y = .65;
        dialoguebox.updateHitbox();
        dialoguebox.screenCenter();
        dialoguebox.color = FlxColor.BLACK;
        dialoguebox.antialiasing = true;
        add(dialoguebox);
        
        dialogueboxdeco = new FlxSprite();
        dialogueboxdeco.antialiasing = true;
        dialogueboxdeco.alpha = .3;
        add(dialogueboxdeco);

        dialoguetext = new FlxTypeText(0,0, Std.int(dialoguebox.width * .5),"hi :-) this is a test.. what if i type too long? will it go down a line?", 54);
		dialoguetext.setFormat('assets/fonts/andy.ttf', 50, FlxColor.WHITE, CENTER);
		dialoguetext.screenCenter();
		dialoguetext.antialiasing = true;
		add(dialoguetext);

        dialogueboxoutline = new FlxSprite();
        dialogueboxoutline.frames = FlxAtlasFrames.fromSparrow('assets/images/dia/diaboxoutline.png', 'assets/images/dia/diaboxoutline.xml');
        dialogueboxoutline.animation.addByPrefix('idle', 'idle', 3);
        dialogueboxoutline.animation.play('idle');
        dialogueboxoutline.scale.y = .65;
        dialogueboxoutline.updateHitbox();
        dialogueboxoutline.screenCenter();
        dialogueboxoutline.color = FlxColor.BLUE;
        dialogueboxoutline.antialiasing = true;
        add(dialogueboxoutline);
        
        visible = false;
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        if(controlallowed){
            if(Controls.getControl('ACCEPT', 'RELEASE')){
                if(finishedtyping){
                    progress ++;
                    dotheline();
                } else {
                    dialoguetext.skip();
                }
            }    
        }

        //dialoguetext.x = dialoguebox.x + dialoguebox.width / 2 - dialoguetext.width / 2; //im stupid why didnt i just center this T-T
        dialoguetext.screenCenter(X);
        dialoguetext.y = dialoguebox.y + 300;

        visible = shouldbevisible; 

        dialogueboxoutline.setPosition(dialoguebox.x, dialoguebox.y);
        dialogueboxdeco.setPosition(dialoguebox.x, dialoguebox.y);
    }

    var thedata:Array<Array<String>> = [];

    var progress:Int = 0;

    public function startDialogue(filename:String, endfunc:Void->Void, ?startfunc:Void -> Void):Void{
        this.endfunc = endfunc;
        this.startfunc = startfunc;

        var notreallythedata = Utilities.dataFromTextFile('assets/data/dia/' + filename + '.txt');

        thedata = [];
        progress = 0;
        dialoguetext.resetText('');
        dialoguetext.start();
        
        for(i in notreallythedata){
            thedata.push(i.split(":"));
        }
        
        shouldbevisible = true;

        updatecolors();

        dialoguebox.y = diaheight;

        FlxTween.tween(dialoguebox, {y: 240}, .5, {ease:FlxEase.quartOut, onComplete: function(f):Void{
            if(startfunc != null) startfunc();
            
            controlallowed = true;
            dotheline();
        }});
    }

    function dotheline():Void{        
        if(progress >= thedata.length){
            finish();
            return;
        }

        finishedtyping = false;
        dialoguetext.completeCallback = function():Void { finishedtyping = true; };

        dialoguetext.resetText(thedata[progress][0]);

        updatecolors();

        dialoguetext.sounds = [FlxG.sound.load('assets/sounds/guy1.ogg'), FlxG.sound.load('assets/sounds/guy2.ogg'), FlxG.sound.load('assets/sounds/guy3.ogg'), FlxG.sound.load('assets/sounds/guy4.ogg')];

        dialoguetext.start(Std.parseFloat(thedata[progress][1]));
    }

    function updatecolors():Void{
        dialoguetext.setFormat('assets/fonts/andy.ttf', 50, FlxColor.WHITE, CENTER);

        dialogueboxdeco.loadGraphic('assets/images/dia/deco_' + thedata[progress][5] + '.png');
        dialogueboxdeco.scale.y = .65;
        dialogueboxdeco.updateHitbox();
        
        var colors = thedata[progress][2].split("-");

        dialoguebox.color = FlxColor.fromRGB(Std.parseInt(colors[0]), Std.parseInt(colors[1]), Std.parseInt(colors[2]));
        dialogueboxdeco.color = FlxColor.fromRGB(Std.parseInt(colors[0]), Std.parseInt(colors[1]), Std.parseInt(colors[2]));

        var othercolors = thedata[progress][3].split("-");

        dialoguetext.color = FlxColor.fromRGB(Std.parseInt(othercolors[0]), Std.parseInt(othercolors[1]), Std.parseInt(othercolors[2]));
        dialogueboxoutline.color = FlxColor.fromRGB(Std.parseInt(othercolors[0]), Std.parseInt(othercolors[1]), Std.parseInt(othercolors[2]));
    }

    function finish(){
        controlallowed = false;
        
        FlxTween.tween(dialoguebox, {y: diaheight}, .5, {ease:FlxEase.quartIn, onComplete: function(f):Void{
            shouldbevisible = false;
            endfunc();
        }});
    }
}