package com.acemobe.spriter.parsers
{
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.Folder;
	import com.acemobe.spriter.SpriterAnimation;

	public class SpriterXML
	{
		public function SpriterXML()
		{
			
		}
			
		public	static	function parse (spriteAnim:SpriterAnimation, data:XML, entities:Array = null, animations:Array = null):void
		{
			for each(var folderXml:XML in data.folder)
			{
				var	folder:Folder = new Folder ();
				folder.parseXML (folderXml);
				
				spriteAnim.folders.push (folder);
			}

			for each(var entityXml:XML in data.entity)
			{
				var	entity:Entity = new Entity ();
				entity.name = entityXml.@name;
				entity.entityData = entityXml;
				
				if (entities == null || entities.indexOf (entity.name) != -1)
				{
					entity.parseXML (spriteAnim, animations);
				}

				spriteAnim.entities.push (entity);
			}
		}
	}
}