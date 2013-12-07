package com.acemobe.spriter.data
{
	public class Ref
	{
		public	var	id:int = 0;
		public	var	parent:int = -1;
		public	var	timeline:int = 0;
		public	var	key:int = 0;
		public	var	z_index:int = 0;

		public	var	abs_pivot_x:Number = 0;
		public	var	abs_pivot_y:Number = 0;

		public function Ref()
		{
		}
		
		public	function parse (refXml:XML):void
		{
			if (refXml.hasOwnProperty("@id"))
				id = refXml.@id;
			if (refXml.hasOwnProperty("@parent"))
				parent = refXml.@parent;
			if (refXml.hasOwnProperty("@timeline"))
				timeline = refXml.@timeline;
			if (refXml.hasOwnProperty("@key"))
				key = refXml.@key;
			if (refXml.hasOwnProperty("@z_index"))
				z_index = refXml.@z_index;
			if (refXml.hasOwnProperty("@abs_pivot_x"))
				abs_pivot_x = refXml.@abs_pivot_x;
			if (refXml.hasOwnProperty("@abs_pivot_y"))
				abs_pivot_y = refXml.@abs_pivot_y;
		}
	}
}