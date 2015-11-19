package;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import Process.Data;

/**
 * ...
 * @author Namide
 */
class View extends Sprite
{
	//public static var MAIN:View;
	
	var _title:TextField;
	var _legend:TextField;
	var _input:TextField;
	var _start:TextField;
	var _button:Sprite;
	var _output:TextField;
	
	public var onClick:String->Void;
	
	public function new() 
	{
		//MAIN = this;
		
		var w = 400;
		var x = 20;
		var h:Float;
		var btnMargin = 4;
		
		super();
		
		
		var format = new TextFormat("Arial", 30, 0x444444, true);
		
		_title = new TextField();
		_title.x = x;
		_title.y = x;
		_title.width = w;
		_title.wordWrap = true;
		_title.text = "Tabular data to SRT";
		_title.setTextFormat(format);
		_title.autoSize = TextFieldAutoSize.LEFT;
		addChild(_title);
		
		
		// ------------------------------
		
		format = new TextFormat("Courrier", 16, 0x000000, false);
		
		_input = new TextField();
		_input.x = x;
		_input.y = _title.y + _title.height + x;
		_input.type = TextFieldType.INPUT;
		_input.text = Data.H1 + ":" + Data.MN1 + "-" + Data.H2 + ":" + Data.MN2 + " " + Data.TEXT;
		_input.setTextFormat(format);
		_input.autoSize = TextFieldAutoSize.LEFT;
		h = _input.height;
		_input.autoSize = TextFieldAutoSize.NONE;
		_input.height = h;
		_input.width = w;
		_input.border = true;
		addChild(_input);
		
		
		// ------------------------------
		
		format = new TextFormat("Arial", format.size, 0x000000, true);
		
		_start = new TextField();
		_start.x = _input.x + _input.width + x;
		_start.y = _input.y;
		_start.text = "START";
		_start.setTextFormat(format);
		_start.autoSize = TextFieldAutoSize.LEFT;
		_start.mouseEnabled = false;
		addChild(_start);
		
		// ------------------------------
		
		_button = new Sprite();
		_button.x = _start.x - btnMargin * 2;
		_button.y = _start.y - btnMargin;
		_button.graphics.beginFill( 0xAAAAAA, 0.5 );
		_button.graphics.drawRoundRect( 0, 0, _start.width + 4 * btnMargin, _start.height + 2 * btnMargin, 10 );
		_button.buttonMode = true;
		_button.addEventListener( MouseEvent.CLICK, function(e:MouseEvent) { onClick(_input.text); } );
		addChildAt(_button, 0);
		
		
		// ------------------------------
		
		format = new TextFormat("Arial", 14, 0xAAAAAA, false);

		_legend = new TextField();
		_legend.x = x;
		_legend.y = _input.y + _input.height + x;
		_legend.width = w;
		_legend.wordWrap = true;
		
		//_legend.text += "Legend\n\n";
		
		_legend.text += Data.H1 + " input hours\n";
		_legend.text += Data.MN1 + " input minutes\n";
		_legend.text += Data.S1 + " input seconds\n";
		_legend.text += Data.MS1 + " input miliseconds\n\n";
		
		_legend.text += Data.H2 + " output hours\n";
		_legend.text += Data.MN2 + " output minutes\n";
		_legend.text += Data.S2 + " output seconds\n";
		_legend.text += Data.MS2 + " output miliseconds\n\n";
		
		_legend.text += Data.TEXT + " subtitle\n";
		
		_legend.setTextFormat(format);
		_legend.autoSize = TextFieldAutoSize.LEFT;
		addChild(_legend);
		
		
		// ------------------------------
		
		format = new TextFormat("Courrier", 12, 0xFFFFFF, false);

		_output = new TextField();
		_output.x = _legend.x + _legend.width + x;
		_output.y = _legend.y;
		_output.width = w;
		_output.wordWrap = true;
		_output.setTextFormat(format);
		_output.backgroundColor = 0x000000;
		addChild(_output);
	}
	
	public inline function trace(s:String) {
		
		_output.appendText(s);// + "\n";
		
	}
	
}