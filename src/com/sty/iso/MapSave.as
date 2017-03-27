package com.sty.iso
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class MapSave
	{
		
		private static var file:File ;
		
		private static var describeData:String ;
		
		private static var _loader:URLLoader ;
		
		public function MapSave()
		{
			
		}
		
		public static function loadDescribe():void{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoad);
			_loader.load(new URLRequest("Describe.txt"));
		}
		
		private static function onLoad(event:Event):void
		{
			describeData = _loader.data;
		}
		
		public static function setMapArray(mapArray:Array):void{
			var saveString:String="";
			for(var i:int = 0 ; i<mapArray.length ; i ++){
				var str:String = (mapArray[i] as Array).toString();
				var myPattern:RegExp = /,/g;           
				str = str.replace(myPattern," ");
				saveString+=str+"\r\n\r\n"
				
			}
			saveTxt(saveString)
		}
		
		public static function  saveTxt(_txt:String):void{
			file = new File();			
			var txt:String =  describeData +"\n" +_txt ; 
			var ff:FileFilter = new FileFilter("txt", "*.txt");
			file.save(txt, "map.txt")
		}
	}
}