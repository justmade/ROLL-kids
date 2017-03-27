package
{
	import com.sty.iso.DrawnIsoBox;
	import com.sty.iso.DrawnIsoTile;
	import com.sty.iso.IsoObject;
	import com.sty.iso.IsoUtils;
	import com.sty.iso.IsoWorld;
	import com.sty.iso.MapLoader;
	import com.sty.iso.MapSave;
	import com.sty.iso.Point3D;
	import com.sty.iso.TextFieldTile;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.text.TextField;
	
	import org.aswing.AsWingManager;
	import org.aswing.EmptyLayout;
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.JWindow;

	[SWF(width="600",height="600")]
	public class FindWayTest extends Sprite
	{
		//基础的世界，地面
		private var world:IsoWorld ;
		
		private var btnDelete:DrawnIsoBox ;
		
		private var btnDrawRoad:DrawnIsoBox ;
		
		private var roadType:String ;
		
		private var roadColor:uint = 0x999999 ;
		
		private var saveArr:Array ; 		
		
		private var file:File
		
		private var mapLoad:MapLoader ;
		
		public static var WINDOW:JWindow;
		
		private var tabpane:JPanel;
		
		private var meun:JMenu
		
		public function FindWayTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			AsWingManager.setRoot(this);
		
			WINDOW = new JWindow(this);
			
			tabpane = new JPanel();
			tabpane.setLayout(new EmptyLayout());
			
			WINDOW.setContentPane(tabpane);
			WINDOW.setSizeWH(600, 600);
			WINDOW.show();
//			initWord();
//			initSaveBtn();
//			initLoadBtn();
//			MapSave.loadDescribe();
			initWindow();
		}
		
		private function initWindow():void{
			var bar:JMenuBar = new JMenuBar();
			meun = new JMenu("File");
			meun.setSizeWH(30,30);
			meun.x = 10;
			meun.y = 10;
			
			var item:JMenuItem = new JMenuItem("New");
			meun.append(item);
			item.addActionListener(onSelectMeun);
			
			item = new JMenuItem("Open");
			meun.append(item);
			item.addActionListener(onSelectMeun);
			
			item = new JMenuItem("Save");
			meun.append(item);
			item.addActionListener(onSelectMeun);
	
			bar.addMenu(meun);
			tabpane.append(bar);
			bar.setSizeWH(30,30);
			
			
		}
		
		private function onSelectMeun(e):void
		{
			var menu:JMenuItem = e.currentTarget as JMenuItem; 
			
			trace(menu.getText() + " clicked!"); 
		}
		
		private function init():void{
			initDeleteBtn();
			initGrassBtn();
			initRoadBtn();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onWorldMouseDown);
		}
		
		private function initWord():void{
			world = new IsoWorld(3,3);
			world.x = stage.stageWidth / 2; 
			world.y = 50;
			addChild(world);
			saveArr = new Array();
			for(var i:int = 0; i < world.cols; i++)
			{
				saveArr[i] = new Array();
				for(var j:int = 0; j < world.rows; j++)
				{
					var tile:DrawnIsoTile = new DrawnIsoTile(20,0xFFFFFF,0);
					tile.position = new Point3D(i * world.cellSize, 0, j * world.cellSize);
					world.addChildToFloor(tile);
				}
			}			
		}
		
		private function getMovingPath():void{
			var box:DrawnIsoTile = new DrawnIsoTile(20,roadColor,0)
			box.roadType = roadType ;
			var pos:Point3D = IsoUtils.screenToIso(new Point(world.mouseX, world.mouseY));
			pos.x = Math.round(pos.x / world.cellSize) * world.cellSize;
			pos.y = Math.round(pos.y / world.cellSize) * world.cellSize;
			pos.z = Math.round(pos.z / world.cellSize) * world.cellSize;
			box.position = pos;
			world.addChildToWorld(box);
		}
		
		private function onWorldMouseDown(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_OVER, onWorldMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP , onWorldMouseUp);
			getMovingPath()
		}
		
		private function onWorldMouseMove(e:MouseEvent):void{
			
			getMovingPath()
		}
		
		private function onWorldMouseUp(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onWorldMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP , onWorldMouseUp);
		}
		
		private function initSaveBtn():void{
			var btnSave:DrawnIsoBox = new DrawnIsoBox(20,0x81faf0,20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(40, 40));
			btnSave.position = pos 
			this.addChild(btnSave);			
			btnSave.addEventListener(MouseEvent.CLICK , onSave);
			
			var tf:TextFieldTile = new TextFieldTile(20,"Save");
			pos = IsoUtils.screenToIso(new Point(70, 20));
			tf.position = pos
			this.addChild(tf);
		}
		
		private function initLoadBtn():void{
			var btnLoad:DrawnIsoBox = new DrawnIsoBox(20,0x934856,20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(40, 100));
			btnLoad.position = pos 
			this.addChild(btnLoad);			
			btnLoad.addEventListener(MouseEvent.CLICK , onLoadMap);
			
			var tf:TextFieldTile = new TextFieldTile(20,"Load");
			pos = IsoUtils.screenToIso(new Point(70, 80));
			tf.position = pos
			this.addChild(tf);
		}
		
		protected function onLoadMap(event:MouseEvent):void
		{
			file = new File();
			var f:FileFilter = new FileFilter("txt文件", "*.txt");
			file.browse([f]);
			file.addEventListener(Event.SELECT, onFileSelect, false, 0, true);
		}
		
		protected function onFileSelect(event:Event):void
		{
			file.addEventListener(Event.COMPLETE, onLoadComplete);
			file.load();			
		}
		
		protected function onLoadComplete(event:Event):void
		{
			mapLoad = new MapLoader();
			mapLoad.addEventListener(Event.COMPLETE , onMapLoadComplete);
			mapLoad.getData(file.data)
		}
		
		protected function onMapLoadComplete(event:Event):void
		{
			mapLoad.addEventListener(Event.COMPLETE , onMapLoadComplete);
			world = mapLoad.makeWorld(20);           
			addChild(world);       
			sizeInit();
			init();
		}
		
		private function sizeInit():void{
			if (world!=null){
				world.x = stage.stageWidth / 2;    
				world.y = 50;
			}
		}
		
		private function initDeleteBtn():void{
			btnDelete = new DrawnIsoBox(20,0xec2a7c,20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(40, 160));
			btnDelete.position = pos 
			this.addChild(btnDelete);			
			btnDelete.addEventListener(MouseEvent.CLICK , onDelete);
			
			var tf:TextFieldTile = new TextFieldTile(20,"Delete");
			pos = IsoUtils.screenToIso(new Point(70, 140));
			tf.position = pos
			this.addChild(tf);
		}
		
		private function initRoadBtn():void{
			btnDrawRoad = new DrawnIsoBox(20,0x999999,20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(40, 220));
			btnDrawRoad.position = pos ;
			this.addChild(btnDrawRoad);
			btnDrawRoad.addEventListener(MouseEvent.CLICK , onDrawRoad);
		}
		
		private function initGrassBtn():void{
			var btnGrass:DrawnIsoBox = new DrawnIsoBox(20,0x86e557,20);
			var pos:Point3D = IsoUtils.screenToIso(new Point(40, 280));
			btnGrass.position = pos ;
			this.addChild(btnGrass);
			btnGrass.addEventListener(MouseEvent.CLICK , onGrassRoad);
		}
		
		//点击草地
		protected function onGrassRoad(event:MouseEvent):void
		{
			roadColor = 0x86e557;
			roadType = "0";
		}
		
		//点击路面
		protected function onDrawRoad(event:MouseEvent):void
		{
			roadColor = 0x999999;
			roadType = "1";
		}
		
		
		
		protected function onDelete(event:MouseEvent):void
		{
			world.deleteCell = !world.deleteCell
			if(world.deleteCell){
				btnDelete.filters = [new GlowFilter(0x7196f6,1,5,5,5)]
			}else{
				btnDelete.filters = [];
			}
		}
		
		
		
		private function onSave(e:MouseEvent):void{
//			MapSave.saveTxt("10101022");
			var arr:Array = world.getAllBox();
			for(var i:int = arr.length; i >=0; i--)
			{       
				var b:* = arr[i];              
				if (b is IsoObject ){
					var tmpI:int = IsoObject(b).position.z / world.cellSize ;
					var tmpJ:int = IsoObject(b).position.x / world.cellSize ;
					saveArr[tmpI][tmpJ] =  IsoObject(b).roadType ;
				}
			}
			MapSave.setMapArray(saveArr);
		}
		
	}
}