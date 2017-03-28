package
{
	import com.sty.controller.KeyboardController;
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.IsoObject;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.Point3D;
	import com.sty.views.CameraView;
	import com.sty.views.MapView;
	
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
		
		private var mapView:MapView;
		
		private var playerBox:DrawnIsoBox;
		
		private var cameraView:CameraView;

		public function Isometric3D()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			cameraView = new CameraView();
			mapView    = new MapView(cameraView)
				
			this.addChild(mapView)

			keyController = new KeyboardController(this.stage);
			this.addEventListener(Event.ENTER_FRAME , onRender)
		}
		
		protected function onRender(event:Event):void
		{
			var point_3d:Point3D = keyController.getKeyboard()
			mapView.setKeyPoint(point_3d)
			mapView.onRender();
//			var location:Point3D = new Point3D(playerBox.x + point_3d.x * (world.cellSize/20) , 0, playerBox.z + point_3d.z * (world.cellSize/20))
//			playerBox.position = location
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
