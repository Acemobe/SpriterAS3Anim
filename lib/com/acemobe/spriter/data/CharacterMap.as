package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class CharacterMap
	{
		public	var		id:int = 0;
		public	var		name:int = 0;
		public	var		maps:Array = [];	
		
		public function CharacterMap()
		{
		}
		
		public	function parse (spriteAnim:SpriterAnimation, characterMapXml:XML):void
		{
			if (characterMapXml.hasOwnProperty("@id"))
				id = characterMapXml.@id;
			if (characterMapXml.hasOwnProperty("@name"))
				name = characterMapXml.@name;
			
			for each(var mapXml:XML in characterMapXml.map)
			{
				var	map:MapInstruction = new MapInstruction ();
				map.parse (spriteAnim, mapXml);
				
				maps.push (map);
			}
		}
	}
}