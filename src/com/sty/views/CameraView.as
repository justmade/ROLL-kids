package com.sty.views
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CameraView
	{
		private var cameraSize:Rectangle;
		
		public var location:Point;
		
		private var perDiff:Point
		
		private var times:int
		
		public function CameraView()
		{
			cameraSize = new Rectangle(0,0,1280,720);
			location = new Point()
		}
		
		public function track(_pos:Point):void{
			this.location.x = _pos.x - cameraSize.width/2
			this.location.y = _pos.y - cameraSize.height/2
		}
		
		public function move(_vel:Point):void{
			this.location = this.location.add(_vel);
		}
		
		public function drop():void{
			times = 5
			var diff:Point = new Point(0,100)
			perDiff = new Point(0,100/5)
		}
		
		public function onTween():void{
			if(times > 0){
				this.location = this.location.add(perDiff);
				times -- 
			}
		}
	}
}