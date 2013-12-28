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
		public	var	entityData:*;
		
		public function Entity()
		{
		}
		
		public	function parseXML (spriteAnim:SpriterAnimation, anims:Array = null):void
		{
			var	xml:XML = entityData as XML;
			
			id = xml.@id;
			
			for each(var objInfoXml:XML in xml.obj_info)
			{
				var	objectInfo:ObjectInfo = new ObjectInfo ();
				objectInfo.parseXML (spriteAnim, objInfoXml);
				
				objectInfos.push(objectInfo);
			}
			
			for each(var characterMapXml:XML in xml.character_map)
			{
				var	characterMap:CharacterMap = new CharacterMap ();
				characterMap.parseXML (spriteAnim, characterMapXml);
				
				characterMaps.push (characterMap);
			}
			
			for each(var animationXml:XML in xml.animation)
			{
				var	animation:Animation = new Animation ();
				animation.name = animationXml.@name;
				animation.animationData = animationXml;

 				if (anims == null || anims.indexOf (animation.name) != -1)
					animation.parseXML (spriteAnim);
				
				animations.push (animation);
			}
			
			loaded = true;
		}

		public	function parse (spriteAnim:SpriterAnimation, anims:Array = null):void
		{
			id = entityData.id;
			
			for each(var objInfoData:* in entityData.obj_info)
			{
				var	objectInfo:ObjectInfo = new ObjectInfo ();
				objectInfo.parse (spriteAnim, objInfoData);
				
				objectInfos.push(objectInfo);
			}
			
			for each(var characterMapData:* in entityData.character_map)
			{
				var	characterMap:CharacterMap = new CharacterMap ();
				characterMap.parse (spriteAnim, characterMapData);
				
				characterMaps.push (characterMap);
			}
			
			for each(var animationData:* in entityData.animation)
			{
				var	animation:Animation = new Animation ();
				animation.name = animationData.name;
				animation.animationData = animationData;
				
				if (anims == null || anims.indexOf (animation.name) != -1)
					animation.parse (spriteAnim);
				
				animations.push (animation);
			}

			loaded = true;
		}
	}
}