package com.acemobe.spriter
{
	import com.acemobe.spriter.parsers.SpriterJSON;
	import com.acemobe.spriter.parsers.SpriterXML;
	
	import starling.textures.TextureAtlas;
	
	public class SpriterAnimation
	{
		public	var	name:String = "";
		
		public	var	folders:Array = [];
		public	var	entities:Array = []; // <entity> tags  
		public	var	activeCharacterMap:Array = [];
		public	var	atlas:TextureAtlas;
		
		public function SpriterAnimation(name:String, data:*, atlas:TextureAtlas = null, entities:Array = null, animations:Array = null)
		{
			this.name = name;
			
			if (data is XML)
				SpriterXML.parse (this, data, entities, animations);
			else 
				SpriterJSON.parse (this, data, entities, animations);
		}
	}
}