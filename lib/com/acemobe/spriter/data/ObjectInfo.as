package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class ObjectInfo
	{
		public	static	var	BOX:int = 0;
		
		public	var	name:String = "";
		public	var	type:int = 0;
		public	var	w:Number;
		public	var	h:Number;
		public	var	pivot_x:Number;
		public	var	pivot_y:Number;

		public function ObjectInfo()
		{
		}
		
		public	function parse (spriteAnim:SpriterAnimation, objectInfoXml:XML):void
		{
			name = objectInfoXml.@name;
			w = objectInfoXml.@w;
			h = objectInfoXml.@h;
			pivot_x = objectInfoXml.@pivot_x;
			pivot_y = objectInfoXml.@pivot_y;

			if (objectInfoXml.hasOwnProperty("@type"))
			{
				if (objectInfoXml.@type == "box")
					type = BOX;
			}
		}
	}
}