package com.acemobe.spriter
{
	import com.acemobe.spriter.data.Animation;
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.SpriteTimelineKey;
	import com.acemobe.spriter.data.TimelineKey;
	
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	public class Spriter extends Sprite implements IAnimatable 
	{
		public	var	animation:SpriterAnimation;
		
		public	var	currentEntity:int = 0;
		public	var	currentAnimation:int = 0; 
		public	var	currentTime:Number = 0.0;
		public	var	currentColor:int = 0xffffff;
		
		protected var imagesByName:Object;

		public	var	baseSprite:Sprite;
		public	var	nextAnim:String = "";

		public function Spriter(name:String, data:XML, atlas:TextureAtlas = null)
		{
			super();
			
			this.name = name;
			
			imagesByName = {};
			
			animation = SpriterCache.findAnimation (name);
			if (!animation)
			{
				animation = SpriterCache.addAnimation(name, new SpriterAnimation (data, atlas));
			}
			
			baseSprite = new Sprite ();
			addChild(baseSprite);
		}
		
		public override function dispose():void
		{
			for (var name:String in imagesByName)
			{
				imagesByName[name].dispose ();
				imagesByName[name] = null;
			}

			baseSprite.removeChildren(0, -1, true);
			removeChildren(0, -1, true);
			
			imagesByName = null;
			
			super.dispose();
		}

		public	function hasAnim (animName:String):Boolean
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			for (var a:int = 0; a < entity.animations.length; a++)
			{
				var	anim:Animation = entity.animations[a] as Animation;
				
				if (anim.name == animName)
				{
					return true;
				}
			}

			return false;
		}
		
		public	function set entity (name:String):void
		{
			for (var a:int = 0; a < animation.entities.length; a++)
			{
				var	entity:Entity = animation.entities[a];
				
				if (entity.name == name)
				{
					currentEntity = a;
					return;
				}
			}			
		}
		
		public	function play (animName:String, nextAnim:String = ""):void
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			this.nextAnim = nextAnim;
			
			for (var a:int = 0; a < entity.animations.length; a++)
			{
				var	anim:Animation = entity.animations[a] as Animation;
				
				if (anim.name == animName)
				{
					if (currentAnimation != a)
					{
						currentAnimation = a;
						currentTime = 0;
					}
					
					if (visible == false)
					{
						visible = true;
						currentTime = 0;
					}
					return;
				}
			}
		}
		
		public function advanceTime(time:Number):void 
		{
			if (!visible)
				return;
			
			currentTime += time;
			
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			var	anim:Animation = entity.animations[currentAnimation] as Animation;
			var	image:Image;
			
			if (anim)
			{
				anim.setCurrentTime (currentTime * 1000);
				
				if (!animation.atlas)
					return;
				
				for (var n:String in imagesByName)
				{
					image = imagesByName[n];
					image.visible = false;
				}
				
				for(var	k:int = 0; k < anim.objectKeys.length; k++)
				{   
					var	key:TimelineKey = anim.objectKeys[k] as TimelineKey;
					
					if (key is SpriteTimelineKey)
					{
						var	spriteKey:SpriteTimelineKey = key as SpriteTimelineKey;
						image = imagesByName[spriteKey.spriteName];
						
						if (!image)
							image = getImageByName (spriteKey);
						
						if (image)
						{
							if (!spriteKey.useDefaultPivot)
							{
								image.pivotX = spriteKey.pivot_x * image.width;
								image.pivotY = spriteKey.pivot_y * image.height;
							}
							
							image.x = spriteKey.info.x;
							image.y = spriteKey.info.y;
							image.scaleX = spriteKey.info.scaleX;
							image.scaleY = spriteKey.info.scaleY;
							image.rotation = deg2rad (fixRotation (spriteKey.info.angle));
							image.visible = true;
							
							baseSprite.addChild(image);
						}
					}
				}

				if (anim.currentTime >= anim.length)
				{
					if (nextAnim != "")
					{
						play (nextAnim);
					}
					else if (anim.loopType == Animation.NO_LOOPING)
					{
						visible = false;						
					}
				}
			}
		}
		
		public	static function fixRotation(rotation:Number):Number 
		{
			while (rotation > 360)
			{
				rotation -= 360;
			}
			
			while (rotation < 0)
			{
				rotation += 360;
			}
			
			return 360 - rotation;
		}

		public function getImage(name:String):Image 
		{
			return imagesByName[name];
		}
		
		public function setColor(value:Number):void 
		{
			for(var name:String in imagesByName)
			{
				imagesByName[name].color = value;
			}
			
			currentColor = value;
		}
		
		protected function getImageByName(key:SpriteTimelineKey):Image
		{
			if (imagesByName[key.spriteName])
			{
				return imagesByName[key.spriteName];
			}
			
			var image:Image			
			var texture:Texture = animation.atlas.getTexture(key.spriteName);
			
			if(!texture)
			{
				texture = animation.atlas.getTexture(key.spriteName2); 
			}
			
			if (texture)
			{
				image = new Image(texture);
				image.name = key.spriteName;
				image.color = currentColor;
				imagesByName[key.spriteName] = image;

				image.pivotX = key.fileRef.pivot_x * key.fileRef.width;
				image.pivotY = (1 - key.fileRef.pivot_y) * key.fileRef.height;
			}
			
			return image;
		}
	}
}