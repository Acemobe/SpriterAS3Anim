package com.acemobe.spriter.data
{
	public class Entity
	{
		public	var	id:int = 0;
		public	var	name:String = "";
		public	var	characterMaps:Array = [];
		public	var	animations:Array = [];
		
		public function Entity()
		{
		}
		
		public	function parse (entityXml:XML):void
		{
			if (entityXml.attribute("id").length())
				id = entityXml.@id;
			if (entityXml.attribute("name").length())
				name = entityXml.@name;
			
			for each(var characetrMapXml:XML in entityXml.character_map)
			{
				var	characterMap:CharacterMap = new CharacterMap ();
				characterMap.parse (characetrMapXml);
				
				characterMaps.push (characterMap);
			}
			
			for each(var animationXml:XML in entityXml.animation)
			{
				var	animation:Animation = new Animation ();
				animation.parse (animationXml);
				
				animations.push (animation);
			}
		}
	}
}