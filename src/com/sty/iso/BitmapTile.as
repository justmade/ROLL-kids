package  com.sty.iso
{   
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData
	
	
	/**
	 *可传入图片的贴图 
	 * @author dell
	 * 
	 */
	public class BitmapTile extends IsoObject
	{
		public function BitmapTile(size:Number, classRef:Class, xoffset:Number, yoffset:Number):void
		{
			super(size);
			var gfx:Bitmap = new Bitmap(new classRef() as BitmapData)
			gfx.x = -xoffset;
			gfx.y = -yoffset;
			addChild(gfx);
		}
	}   
}