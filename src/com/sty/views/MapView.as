package com.sty.views
{
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Camera;

	public class MapView extends Sprite
	{
		private var world:IsoWorld;
		
		private var playerBox:DrawnIsoBox;
		
		private var mapSp:Sprite;
		
		private var playerSp:Sprite
		
		private var camera:CameraView
		
		//z
		private var row:int = 2;
		//x
		private var col:int = 10;
		
		private var cellSize:int = 50
		public function MapView(_camera:CameraView)
		{
			camera   = _camera
			mapSp	 = new Sprite()
			playerSp = new Sprite();
			world    = new IsoWorld(col,row,cellSize);
			this.addChild(mapSp)
			this.addChild(playerSp)
			sizeInit();
			mapSp.addChild(world);
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var tile:DrawnIsoTile = new DrawnIsoTile(world.cellSize, 0xcccccc);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
			addBox()
			var p:Point = IsoUtils.isoToScreen(playerBox.position)
			camera.track(p)
		}
		
		private function sizeInit():void{
//			world.x = 1280 / 2;
//			world.y = 720 /2;
		}
		
		private function addBox():void{
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, Math.random() * 0xffffff, world.cellSize);
			var pos:Point3D = new Point3D(0,0,0)
			box.position = pos;
			world.addChildToWorld(box);
			playerBox = box
		}
		
		public function setKeyPoint(point_3d:Point3D):void{
			var location:Point3D = new Point3D(playerBox.x + point_3d.x * (world.cellSize/20) , 0, playerBox.z + point_3d.z * (world.cellSize/20))
			playerBox.position = location
		}
		
		public function onRender():void{			
			var p:Point = IsoUtils.isoToScreen(playerBox.position)
			camera.track(p)
			var px:Number = camera.location.x;
			var py:Number = camera.location.y;
			mapSp.x = -px
			mapSp.y = -py		
				
			trace(world.hasFloor(playerBox))
		}
	}
}