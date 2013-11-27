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
			if (refXml.attribute("id").length())
				id = refXml.@id;
			if (refXml.attribute("parent").length())
				parent = refXml.@parent;
			if (refXml.attribute("timeline").length())
				timeline = refXml.@timeline;
			if (refXml.attribute("key").length())
				key = refXml.@key;
			if (refXml.attribute("z_index").length())
				z_index = refXml.@z_index;
			if (refXml.attribute("abs_pivot_x").length())
				abs_pivot_x = refXml.@abs_pivot_x;
			if (refXml.attribute("abs_pivot_y").length())
				abs_pivot_y = refXml.@abs_pivot_y;
		}
	}
}