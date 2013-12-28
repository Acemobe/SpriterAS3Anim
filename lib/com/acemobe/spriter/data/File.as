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
		
		public	function parseXML (fileXml:XML):void
		{
			id = fileXml.@id;

			name = fileXml.@name;
			
			var	pos:int = name.lastIndexOf(".png");
			if (pos != -1)
			{
				name = name.substr(0, pos);
			}
			
			width = fileXml.@width;
			height = fileXml.@height;
			pivot_x = fileXml.@pivot_x;
			pivot_y = fileXml.@pivot_y;
		}

		public	function parse (file:*):void
		{
			id = file.id;
			name = file.name;
				
			var	pos:int = name.lastIndexOf(".png");
			if (pos != -1)
			{
				name = name.substr(0, pos);
			}

			width = file.width;
			height = file.height;
			pivot_x = file.pivot_x;
			pivot_y = file.pivot_y;
		}
	}
}