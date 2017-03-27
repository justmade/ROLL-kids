package 
{
	
	import flash.display.*;
	import flash.events.*;  
	import flash.geom.Point;
	import com.sty.iso.*
	
	[SWF(backgroundColor=0xffffff,height=260,width=460)]
	public class GraphicTest extends Sprite
	{
		private var world:IsoWorld;
		
		[Embed(source="tile_01.png")]
		private var Tile01:Class;
		
		[Embed(source="tile_02.png")]
		private var Tile02:Class
		
		public function GraphicTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			world = new IsoWorld();
			sizeInit();
			addChild(world);
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var tile:GraphicTile = new GraphicTile(world.cellSize, Tile01, 20, 10);
					tile.position = new Point3D(i * world.cellSize, 10, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
			stage.addEventListener(MouseEvent.CLICK, onWorldClick);
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		private function sizeInit():void{
			world.x = stage.stageWidth / 2; 
			world.y = 50;
		}
		
		
		private function resizeHandler(e:Event):void{           
			sizeInit();     
		}
		
		private function onWorldClick(event:MouseEvent):void
		{
			var box:GraphicTile = new GraphicTile(world.cellSize, Tile02, 20, 30);
			var pos:Point3D = IsoUtils.screenToIso(new Point(world.mouseX, world.mouseY));
			pos.x = Math.round(pos.x / world.cellSize) * world.cellSize;
			pos.y = Math.round(pos.y / world.cellSize) * world.cellSize;
			pos.z = Math.round(pos.z / world.cellSize) * world.cellSize;
			box.position = pos;
			world.addChildToWorld(box);
		}
	}
}