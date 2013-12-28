package com.acemobe.spriter.parsers
{
	import com.acemobe.spriter.SpriterAnimation;
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.Folder;

	public class SpriterJSON
	{
		public function SpriterJSON()
		{
		}

		public	static	function parse (spriteAnim:SpriterAnimation, data:*, entities:Array = null, animations:Array = null):void
		{
			for each(var folderData:* in data.folder)
			{
				var	folder:Folder = new Folder ();
				folder.parse (folderData);
				
				spriteAnim.folders.push (folder);
			}
			
			for each(var entityData:* in data.entity)
			{
				var	entity:Entity = new Entity ();
				entity.name = entityData.name;
				entity.entityData = entityData;
				
				if (entities == null || entities.indexOf (entity.name) != -1)
				{
					entity.parse (spriteAnim, animations);
				}
				
				spriteAnim.entities.push (entity);
			}
		}
	}
}