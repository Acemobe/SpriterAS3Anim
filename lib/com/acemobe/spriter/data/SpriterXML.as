package com.acemobe.spriter.data
{
	import com.acemobe.spriter.SpriterAnimation;

	public class SpriterXML
	{
		public function SpriterXML()
		{
			
		}
			
		public	static	function parse (spriteAnim:SpriterAnimation, data:XML):void
		{
			for each(var folderXml:XML in data.folder)
			{
				var	folder:Folder = new Folder ();
				folder.parse (folderXml);
				
				spriteAnim.folders.push (folder);
			}

			for each(var entityXml:XML in data.entity)
			{
				var	entity:Entity = new Entity ();
				entity.parse (entityXml);
				
				spriteAnim.entities.push (entity);
			}
		}
	}
}