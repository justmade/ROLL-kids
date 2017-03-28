package com.sty.views
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CameraView
	{
		private var cameraSize:Rectangle;
		public var location:Point;
		
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
	}
}