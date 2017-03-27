package
{
	import com.sty.iso.*
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	[SWF(backgroundColor=0xffffff,height=260,width=460)]
	public class CollisionTest extends Sprite
	{
		private var world:IsoWorld;
		private var box:DrawnIsoBox;
		private var speed:Number = 4;
		public function CollisionTest()
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
					var tile:DrawnIsoTile = new DrawnIsoTile(world.cellSize, 0xcccccc);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}
			box = new DrawnIsoBox(world.cellSize, 0xff0000, world.cellSize);
			box.x = world.cellSize*Math.round(world.cols/2);
			box.z = world.cellSize*Math.round(world.rows/2);
			world.addChildToWorld(box);
			
			//再放一个静止的box            
			var newBox:DrawnIsoBox = new DrawnIsoBox(world.cellSize, 0xcccccc, world.cellSize);
			newBox.x = box.x + 2*world.cellSize;
			newBox.z = box.z + 2*world.cellSize;
			world.addChildToWorld(newBox);
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		private function sizeInit():void{
			world.x = stage.stageWidth / 2; 
			world.y = 50;
		}
		
		
		private function resizeHandler(e:Event):void{           
			sizeInit();     
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP :
					box.vx = -speed;
					break; 111
				case Keyboard.DOWN :
					box.vx = speed;
					break;
				case Keyboard.LEFT :
					box.vz = speed;
					break;
				case Keyboard.RIGHT :
					box.vz = -speed;
					break;
				default :
					break;
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onKeyUp(event:KeyboardEvent):void
		{
			box.vx = 0;
			box.vz = 0;
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{           
			if(world.canMove(box)){
				box.x += box.vx;
				box.y += box.vy;
				box.z += box.vz;            
			}
			world.sort();
		}
	}
}