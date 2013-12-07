package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class Entity
	{
		public	var	id:int = 0;
		public	var	name:String = "";
		public	var	characterMaps:Array = [];
		public	var	animations:Array = [];
		
		public function Entity()
		{
		}
		
		public	function parse (spriteAnim:SpriterAnimation, entityXml:XML):void
		{
			if (entityXml.hasOwnProperty("@id"))
				id = entityXml.@id;
			if (entityXml.hasOwnProperty("@name"))
				name = entityXml.@name;
			
			for each(var characetrMapXml:XML in entityXml.character_map)
			{
				var	characterMap:CharacterMap = new CharacterMap ();
				characterMap.parse (spriteAnim, characetrMapXml);
				
				characterMaps.push (characterMap);
			}
			
			for each(var animationXml:XML in entityXml.animation)
			{
				var	animation:Animation = new Animation ();
				animation.parse (spriteAnim, animationXml);
				
				animations.push (animation);
			}
		}
	}
}