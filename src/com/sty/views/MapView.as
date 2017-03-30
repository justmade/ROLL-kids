package com.sty.views
{
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.GraphicTile;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.media.Camera;
	
	import data.ElementType;
	import data.MapData;

	public class MapView extends Sprite
	{
		[Embed(source="../../../grass.png")]
		private var Tile_Grass:Class
		
		private var world:IsoWorld;
		
		private var hittestBox:DrawnIsoBox;
		
		private var playerBox:DrawnIsoBox
		
		private var mapSp:Sprite;
		
		private var playerSp:Sprite
		
		private var camera:CameraView
		
		//z
		private var row:int = 10;
		//x
		private var col:int = 10;
		
		private var cellSize:int = 40
		
		private var playerDrop:Boolean = false
			
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
			
			var map:Array = MapData.Maps[0];
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var index:int = j * 10 + i
					var value:int = map[index]
					if (value == 2){
						var tile:GraphicTile = new GraphicTile(world.cellSize, Tile_Grass, 40, 35);
						tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
						world.addChildToFloor(tile);
						
					}else if(value == 3){
						var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, 0x00b021, world.cellSize);
						box.position =new Point3D(i * world.cellSize, 0, j * world.cellSize);
						world.addChildToWorld(box);
					}
					
				}
			}
			addBox()
			var p:Point = IsoUtils.isoToScreen(hittestBox.position)
			camera.track(p)
		}
		
		private function sizeInit():void{
//			world.x = 1280 / 2;
//			world.y = 720 /2;
		}
		
		private function addBox():void{
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, Math.random() * 0xffffff, world.cellSize,0.2,ElementType.PLAYER);
			var pos:Point3D = new Point3D(0,0,0)
			box.position = pos;
			world.addChildToWorld(box);
			hittestBox = box
				
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, Math.random() * 0xffffff, world.cellSize,1,ElementType.PLAYER);
			var pos:Point3D = new Point3D(0,0,0)
			box.position = pos;
			world.addChildToWorld(box);
			playerBox = box
		}
		
		public function setKeyPoint(point_3d:Point3D):void{
			var location:Point3D = new Point3D(hittestBox.x + point_3d.x * (world.cellSize/20) , hittestBox.y, hittestBox.z + point_3d.z * (world.cellSize/20))
			hittestBox.position = location
			var canMove:Boolean =  world.canMove(hittestBox)	
			if(canMove){
				playerBox.position = location
			}else{
				location = new Point3D(hittestBox.x - point_3d.x * (world.cellSize/20) , hittestBox.y, hittestBox.z - point_3d.z * (world.cellSize/20))
				hittestBox.position = location
			}
			world.sort()
		}
		
		public function onRender():void{			
			var p:Point = IsoUtils.isoToScreen(playerBox.position)
			camera.track(p)
			var px:Number = camera.location.x;
			var py:Number = camera.location.y;
			mapSp.x = -px
			mapSp.y = -py	
				
			var hasFloor:Boolean = world.hasFloor(hittestBox)
			if(!hasFloor && !playerDrop){
				playerDrop = true
				hittestBox.drop();
				playerBox.drop();
			}
			hittestBox.onRender();
			playerBox.drop();
			
		}
	}
}