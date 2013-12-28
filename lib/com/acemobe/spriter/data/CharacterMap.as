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
		
		public	function parseXML (spriteAnim:SpriterAnimation, characterMapXml:XML):void
		{
			id = characterMapXml.@id;
			name = characterMapXml.@name;
			
			for each(var mapXml:XML in characterMapXml.map)
			{
				var	map:MapInstruction = new MapInstruction ();
				map.parseXML (spriteAnim, mapXml);
				
				maps.push (map);
			}
		}

		public	function parse (spriteAnim:SpriterAnimation, characterMapData:*):void
		{
			id = characterMapData.id;
			name = characterMapData.name;
			
			for each(var mapXml:* in characterMapData.map)
			{
				var	map:MapInstruction = new MapInstruction ();
				map.parse (spriteAnim, mapXml);
				
				maps.push (map);
			}
		}
	}
}