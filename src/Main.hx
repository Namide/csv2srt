package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var MAIN:Main;
	
	
	
	
	var _view:View;
	var _process:Process;
	
	
	
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		MAIN = new Main();
		
		
		var r = new EReg("haxe", "i");
		
		
	}
	
	function new()
	{
		
		_view = new View();
		_view.onClick = runProcess;
		Lib.current.stage.addChild( _view);
		
		
	}
	
	inline function runProcess(command)
	{
		_process = new Process(command, _view);
	}
	
}