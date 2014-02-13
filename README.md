SpriterAS3Anim
==============

AS3 code to animate Spriter Animations.


	var	atlas:TextureAtlas = mAssetManager.getTextureAtlas("player-atlas");		// load the texture atlas
	var	xml:XML = mAssetManager.getXml("player");								// load the scml
	var	name:String = "player";
	var 	anim:String = "idle";

	var	s:Spriter = new Spriter (name,anim, xml, atlas);								// create an instance of a spriter animation
	s.play ("idle");
	
	addChild(s);
	Starling.juggler.add(s);

	
