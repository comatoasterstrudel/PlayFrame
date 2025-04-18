package playframe.helpers;

class SaveData{
    public static var highscores:Map<String, Int> = [
        'hexie' => 0,
        'gerbo' => 0,
        '8head' => 0,
        'trifecta' => 0
    ];
    
    public static function init():Void{
        FlxG.save.bind('playframe');    
    }
    
    public static function load():Void{
        FlxG.save.bind('playframe');    
        
        if(FlxG.save.data.savedAvatar != null) {
            PlayState.curAvatar = FlxG.save.data.savedAvatar;
        } else {
            PlayState.curAvatar = 'hexie';
        }
        
        if(FlxG.save.data.highscores != null){
            highscores = FlxG.save.data.highscores;
        } else {
            highscores = [
                'hexie' => 0,
                'gerbo' => 0,
                '8head' => 0,
                'trifecta' => 0
            ];
        }
        
        trace('Loaded Save Data');
    }
    
    public static function save():Void{
        FlxG.save.bind('playframe');    

        FlxG.save.data.savedAvatar = PlayState.curAvatar;
    
        FlxG.save.data.highscores = highscores;
        
        FlxG.save.flush();
        
        trace('Saved Save Data');
    }   
}