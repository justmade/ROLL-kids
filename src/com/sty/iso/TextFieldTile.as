package com.sty.iso
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextFieldTile extends IsoObject
	{
		public function TextFieldTile(objSize:Number,_text:String,_color:uint=0x000000,_size:int = 22)
		{
			super(objSize);						
			var tf:TextField = new TextField();
			tf.text = _text;
			tf.defaultTextFormat = new TextFormat(null,_size,_color);
			tf.width =tf.textWidth + 5;
			tf.height = tf.textHeight+5;
			tf.mouseEnabled = false;
			this.addChild(tf);
		}
	}
}