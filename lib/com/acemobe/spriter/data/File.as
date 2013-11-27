package com.acemobe.spriter.data
{
	public class File
	{
		public	var		id:int = 0;
		public	var		name:String = "";
		public	var		width:Number = 0;
		public	var		height:Number = 0;
		public	var		pivot_x:Number = 0;
		public	var		pivot_y:Number = 1;
		
		public function File()
		{
		}
		
		public	function parse (fileXml:XML):void
		{
			if (fileXml.attribute("id").length())
				id = fileXml.@id;
			if (fileXml.attribute("name").length())
			{
				name = fileXml.@name;
				
				var	pos:int = name.lastIndexOf(".png");
				name = name.substr(0, pos);
			}
			if (fileXml.attribute("width").length())
				width = fileXml.@width;
			if (fileXml.attribute("height").length())
				height = fileXml.@height;
			if (fileXml.attribute("pivot_x").length())
				pivot_x = fileXml.@pivot_x;
			if (fileXml.attribute("pivot_y").length())
				pivot_y = fileXml.@pivot_y;
		}
	}
}