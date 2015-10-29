package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.Lib;
import flash.net.FileFilter;
import flash.net.FileReference;

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var MAIN:Main;
	
	var _fileRef:FileReference;
	var _n:Int;
	var _out:String;
	var _error:String;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		MAIN = new Main();
	}
	
	function new()
	{
		_fileRef = new FileReference();
		_fileRef.addEventListener(Event.SELECT, onSelect);
		_fileRef.addEventListener(IOErrorEvent.IO_ERROR, addIOError);
        _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, addSecurityError);
        _fileRef.browse([new FileFilter("*.csv", "*.csv")]);
		
		_out = "";
		_error = "";
		_n = 1;
	}
	
	function addIOError(e:IOErrorEvent) { _error += e.text + "\r\n"; }
	function addSecurityError(e:SecurityErrorEvent) { _error += e.text + "\r\n"; }
	
	function onSelect(e:Event)
	{
		_fileRef.removeEventListener(Event.SELECT, onSelect);
		_fileRef.addEventListener(Event.COMPLETE, onLoad);
		_fileRef.load();
	}
	
	function onLoad(e:Event)
	{
		var s:String = _fileRef.data.toString();
		
		var a = s.split("\r\n");
		for (c in a) {
			analyseLine(c);
		}
		
		var fileRef = new FileReference();
		fileRef.save(_out, _fileRef.name + ".srt" );
	}
	
	function analyseLine(s:String) {
		
		if (s == "")
			return;
			
		var datas = s.split("|");
		if (datas.length < 2)
			return;
			
		
		var dates = datas[0].split("-");
		if (dates.length < 2)
			return;
		
		
		
		_out += _n + "\r\n";
		_out += "00:" + dates[0] + ",000 --> 00:" + dates[1] + ",000\r\n";
		_out += datas[1] + "\r\n\r\n";
		
		_n++;
	}
	
}