package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class Entity
	{
		public	var	id:int = 0;
		public	var	name:String = "";
		public	var	loaded:Boolean = false;
		public	var	characterMaps:Array = [];
		public	var	animations:Array = [];
		public	var	objectInfos:Array = [];
		public	var	entityXml:XML;
		
		public function Entity()
		{
		}
		
		public	function parse (spriteAnim:SpriterAnimation, anims:Array = null):void
		{
			if (entityXml.hasOwnProperty("@id"))
				id = entityXml.@id;
			
			for each(var objInfoXml:XML in entityXml.obj_info)
			{
				var	objectInfo:ObjectInfo = new ObjectInfo ();
				objectInfo.parse (spriteAnim, objInfoXml);
				
				objectInfos.push(objectInfo);
			}
			
			for each(var characterMapXml:XML in entityXml.character_map)
			{
				var	characterMap:CharacterMap = new CharacterMap ();
				characterMap.parse (spriteAnim, characterMapXml);
				
				characterMaps.push (characterMap);
			}
			
			for each(var animationXml:XML in entityXml.animation)
			{
				var	animation:Animation = new Animation ();
				animation.name = animationXml.@name;
				animation.animationXml = animationXml;

 				if (anims == null || anims.indexOf (animation.name) != -1)
					animation.parse (spriteAnim);
				
				animations.push (animation);
			}
			
			loaded = true;
		}
	}
}