package;

import flash.display.StageScaleMode;
import flash.errors.Error;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.Lib;
import flash.net.FileFilter;
import flash.net.FileReference;

@:enum
abstract Data(String)
{
	var H1 = "H1";
	var MN1 = "MN1";
	var S1 = "S1";
	var MS1 = "MS1";
	
	var H2 = "H2";
	var MN2 = "MN2";
	var S2 = "S2";
	var MS2 = "MS2";
	
	var TEXT = "TEXT";
	
	inline function new( s:String ){ this = s; }

	@:from
	public static function fromString(s:String):Data {
	    return new Data(s);
	}
	
	@:to
	public function toString():String {
	    return this;
	}
}

typedef Subtitle = {
	
	var h1:Int;
	var mn1:Int;
	var s1:Int;
	var ms1:Int;
	
	var h2:Int;
	var mn2:Int;
	var s2:Int;
	var ms2:Int;
	
	var text:String;
}

/**
 * ...
 * @author Namide
 */
class Process
{
	public static var H1:String = "H1";
	public static var MN1:String = "MN1";
	public static var S1:String = "S1";
	public static var MS1:String = "MS1";
	
	public static var H2:String = "H2";
	public static var MN2:String = "MN2";
	public static var S2:String = "S2";
	public static var MS2:String = "MS2";
	
	public static var TEXT:String = "TEXT";
	
	
	
	var _fileRef:FileReference;
	var _n:Int;
	var _out:String;
	var _command:String;
	
	var _view:View;
	
	public function new(command:String, view:View) 
	{
		_command = command;
		_view = view;
		
		_fileRef = new FileReference();
		_fileRef.addEventListener(Event.SELECT, onSelect);
		_fileRef.addEventListener(IOErrorEvent.IO_ERROR, addIOError);
        _fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, addSecurityError);
        _fileRef.browse([new FileFilter("*.csv;*.txt", "*.csv;*.txt")]);
		
		_out = "";
		_n = 1;
	}
	
	function addIOError(e:IOErrorEvent) { _view.aff(e.text); }
	function addSecurityError(e:SecurityErrorEvent) { _view.aff(e.text); }
	
	function onSelect(e:Event)
	{
		_fileRef.removeEventListener(Event.SELECT, onSelect);
		_fileRef.addEventListener(Event.COMPLETE, onLoad);
		_fileRef.load();
	}
	
	function onLoad(e:Event)
	{
		var s:String = _fileRef.data.toString();
		
		_view.aff("Start process");
		
		var a = s.split("\r\n");
		var aCommand = getACommand(_command);
		
		var l:Int = 0;
		for (i in 0...a.length) {
			
			try
			{
				var c = a[i];
				l += analyseLine(c, i, aCommand);
			}
			catch (e:Error)
			{
				return _view.aff("Error line " + (i + 1));
			}
		}
		
		_view.aff("Process finished for " + l + " lines");
		_view.aff(" ");
		
		var fileRef = new FileReference();
		fileRef.save(_out, _fileRef.name + ".srt" );
	}
	
	function analyseLine(s:String, i:Int, aCommand:Array<{delimiter:Bool, ?type:Data, str:String}>):Int {
		
		if (s == "")
		{
			_view.aff("Empty line in " + (i + 1));
			return 0;
		}
		
		var sub:Subtitle = { h1:0, mn1:0, s1:0, ms1:0, h2:0, mn2:0, s2:0, ms2:0, text:"" };
		
		var cmd = aCommand.concat([]);
		var delimiter = "";
		while (cmd.length > 0)
		{
			
			if ( cmd[0].delimiter )
			{
				delimiter = cmd[0].str;
				var a = s.split(delimiter);
				a.shift();
				s = a.join(delimiter);
			}
			else
			{
				var data = s;
				var type = cmd[0].type;
				
				if (cmd.length > 1)
				{
					delimiter = cmd[1].str;
					var a = s.split(delimiter);
					data = a[0];
					a.shift();
					s = a.join(delimiter);
					cmd.shift();
				}
				else
				{
					s = "";
				}
				
				switch (type)
				{
					case Data.H1 : 		sub.h1 = Std.parseInt(data);
					case Data.MN1 : 	sub.mn1 = Std.parseInt(data);
					case Data.S1 : 		sub.s1 = Std.parseInt(data);
					case Data.MS1 : 	sub.ms1 = Std.parseInt(data);
					case Data.H2 : 		sub.h2 = Std.parseInt(data);
					case Data.MN2 : 	sub.mn2 = Std.parseInt(data);
					case Data.S2 : 		sub.s2 = Std.parseInt(data);
					case Data.MS2 : 	sub.ms2 = Std.parseInt(data);
					case Data.TEXT : 	sub.text = data;
				}
			}
			
			cmd.shift();
		}
		
		_out += _n + "\r\n";
		_out += i2s(sub.h1) + ":" + i2s(sub.mn1) + ":" + i2s(sub.s1) + "," + i2s(sub.ms1, 3) + " --> " + i2s(sub.h2) + ":" + i2s(sub.mn2) + ":" + i2s(sub.s2) + "," + i2s(sub.ms2, 3) + "\r\n";
		_out += sub.text + "\r\n\r\n";
		
		_n++;
		
		return 1;
	}
	
	function getACommand ( command:String ) {
		
		var list = [Data.H1, Data.MN1, Data.S1, Data.MS1, Data.H2, Data.MN2, Data.S2, Data.MS2, Data.TEXT];
		var order:Array<Data> = [];
		var commandTemp = command;
		
		while ( list.length > 0 ) {
			
			var r: { l:Int, type:Data } = { l:0xFFFFFF, type:Data.TEXT };
		
			for (type in list) {
				var a = commandTemp.split(type.toString());
				var rTemp = { l:a[0].length, type:type };
				
				if ( rTemp.l < r.l )
					r = rTemp;
			}
			
			if (r.l < commandTemp.length)
			{
				var aTemp = commandTemp.split(r.type.toString());
				aTemp.shift();
				commandTemp = aTemp.join(r.type.toString());
				
				order.push( r.type );
				list.shift();
			}
			else
			{
				list = [];
			}
		}
		
		var out:Array<{delimiter:Bool, ?type:Data, str:String}> = [];
		var commandTemp = command;
		var a:Array<String> = [];
		for (type in order) {
			
			a = commandTemp.split(type.toString());
			
			if (a[0].length > 0)
				out.push( { delimiter:true, str:a[0] } );
			
			out.push( { delimiter:false, type:type, str:type.toString() } );
			
			var aTemp = a.concat([]);
			aTemp.shift();
			commandTemp = aTemp.join(type.toString());
		}
		if (a.length > 2)
			out.push( { delimiter:true, str:a[2] } );
		
		var info = "Command: \"";
		for (d in out)
			info += d.str;
		info += "\"";
		_view.aff(info);
		
		return out;
	}
	
	function shift(s:String) : {restLine:String, element:String, type:Data }
	{
		return { restLine:s, element:s, type:Data.H1 };
	}
	
	function i2s( i:Int, ?n:Int = 2 ) : String
	{
		var s = Std.string(i);
		
		while (s.length < n)
			s = "0" + s;
		
		return s;
	}
	
}