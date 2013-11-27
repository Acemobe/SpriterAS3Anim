SpriterAS3Anim
==============

AS3 code to animate Spriter Animations.


	var	atlas:TextureAtlas = mAssetManager.getTextureAtlas("player-atlas");		// load the texture atlas
	var	xml:XML = mAssetManager.getXml("player");								// load the scml
	var	name:String = "player";

	var	s:Spriter = new Spriter (name, xml, atlas);								// create an instance of a spriter animation
	s.play ("idle");
	
	addChild(s2);
	Starling.juggler.add(s2);

	