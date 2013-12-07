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
			if (fileXml.hasOwnProperty("@id"))
				id = fileXml.@id;
			if (fileXml.hasOwnProperty("@name"))
			{
				name = fileXml.@name;
				
				var	pos:int = name.lastIndexOf(".png");
				name = name.substr(0, pos);
			}
			if (fileXml.hasOwnProperty("@width"))
				width = fileXml.@width;
			if (fileXml.hasOwnProperty("@height"))
				height = fileXml.@height;
			if (fileXml.hasOwnProperty("@pivot_x"))
				pivot_x = fileXml.@pivot_x;
			if (fileXml.hasOwnProperty("@pivot_y"))
				pivot_y = fileXml.@pivot_y;
		}
	}
}