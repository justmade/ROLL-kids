package
{
	import com.sty.controller.KeyboardController;
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.IsoObject;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[SWF(width="1280",height="720")]
	public class Isometric3D extends Sprite
	{

		private var world:IsoWorld;
		
		private var keyController:KeyboardController;
		
		private var playerBox:DrawnIsoBox;

		public function Isometric3D()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			world = new IsoWorld(10,10,50);
			sizeInit();


			addChild(world);
			for(var i:int = 0; i < world.cols; i++)
			{
				for(var j:int = 0; j < world.rows; j++)
				{
					var tile:DrawnIsoTile = new DrawnIsoTile(world.cellSize, 0xcccccc);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
//			stage.addEventListener(MouseEvent.CLICK, onWorldClick);
//			stage.addEventListener(Event.RESIZE,resizeHandler);
			addBox();
			keyController = new KeyboardController(this.stage);
			this.addEventListener(Event.ENTER_FRAME , onRender)
		}
		
		protected function onRender(event:Event):void
		{
			var point_3d:Point3D = keyController.getKeyboard()
			var location:Point3D = new Point3D(playerBox.x + point_3d.x * (world.cellSize/20) , 0, playerBox.z + point_3d.z * (world.cellSize/20))
			playerBox.position = location
		}
		
		private function sizeInit():void{
			world.x = stage.stageWidth / 2;
			world.y = stage.stageHeight/2;
		}

		private function resizeHandler(e:Event):void{
			sizeInit();
		}
		
		private function addBox():void{
			
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, Math.random() * 0xffffff, world.cellSize);
			var pos:Point3D = new Point3D(0,0,0)
//			pos.x = Math.round(pos.x / world.cellSize) * world.cellSize;
//			pos.y = Math.round(pos.y / world.cellSize) * world.cellSize;
//			pos.z = Math.round(pos.z / world.cellSize) * world.cellSize;
		
			box.position = pos;
			world.addChildToWorld(box);
			playerBox = box
		}

		private function onWorldClick(event:MouseEvent):void
		{
			var box:DrawnIsoBox = new DrawnIsoBox(world.cellSize, Math.random() * 0xffffff, world.cellSize);
			var pos:Point3D = IsoUtils.screenToIso(new Point(world.mouseX, world.mouseY));
			pos.x = Math.round(pos.x / world.cellSize) * world.cellSize;
			pos.y = Math.round(pos.y / world.cellSize) * world.cellSize;
			pos.z = Math.round(pos.z / world.cellSize) * world.cellSize;
			box.position = pos;
			world.addChildToWorld(box);
			
		}
	}
}
