package com.acemobe.spriter
{
	import com.acemobe.spriter.parsers.SpriterJSON;
	import com.acemobe.spriter.parsers.SpriterXML;
	
	import starling.textures.TextureAtlas;

	public class SpriterAnimation
	{
		public	var	folders:Array = [];
		public	var	entities:Array = []; // <entity> tags  
		public	var	activeCharacterMap:Array = [];
		public	var	atlas:TextureAtlas;
		
		public function SpriterAnimation(data:*, atlas:TextureAtlas, entities:Array = null, animations:Array = null)
		{
			this.atlas = atlas;
			
			if (data is XML)
				SpriterXML.parse (this, data, entities, animations);
			else 
				SpriterJSON.parse (this, data, entities, animations);
		}
	}
}