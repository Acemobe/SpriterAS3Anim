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
		
		public	function parseXML (refXml:XML):void
		{
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

		public	function parse (refData:*):void
		{
			id = refData.id;

			if (refData.hasOwnProperty("parent"))
				parent = refData.parent;
			if (refData.hasOwnProperty("timeline"))
				timeline = refData.timeline;
			if (refData.hasOwnProperty("key"))
				key = refData.key;
			if (refData.hasOwnProperty("z_index"))
				z_index = refData.z_index;
			if (refData.hasOwnProperty("abs_pivot_x"))
				abs_pivot_x = refData.abs_pivot_x;
			if (refData.hasOwnProperty("abs_pivot_y"))
				abs_pivot_y = refData.abs_pivot_y;
		}
	}
}