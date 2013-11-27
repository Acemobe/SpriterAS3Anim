package com.acemobe.spriter.data
{
	public class CharacterMap
	{
		public	var		id:int = 0;
		public	var		name:int = 0;
		public	var		maps:Array = [];	
		
		public function CharacterMap()
		{
		}
		
		public	function parse (characterMapXml:XML):void
		{
			if (characterMapXml.attribute("id").length())
				id = characterMapXml.@id;
			if (characterMapXml.attribute("name").length())
				name = characterMapXml.@name;
			
			for each(var mapXml:XML in characterMapXml.map)
			{
				var	map:MapInstruction = new MapInstruction ();
				map.parse (mapXml);
				
				maps.push (map);
			}
		}
	}
}