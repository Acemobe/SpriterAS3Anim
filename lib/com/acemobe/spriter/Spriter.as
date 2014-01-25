package com.acemobe.spriter
{
	import com.acemobe.spriter.data.Animation;
	import com.acemobe.spriter.data.BoxTimelineKey;
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.PointTimelineKey;
	import com.acemobe.spriter.data.SpriteTimelineKey;
	import com.acemobe.spriter.data.TimelineKey;
	
	import starling.animation.IAnimatable;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	public class Spriter extends Sprite implements IAnimatable 
	{
		private	var	animation:SpriterAnimation;
		
		private	var	currentEntity:int = 0;
		private	var	currentAnimation:int = -1; 
		private	var	currentTime:Number = 0.0;
		private	var	currentColor:int = 0xffffff;
		
		private	var	mCallBack:* = null;
		
		public	var	playbackSpeed:Number = 1;
		public	var	activePoints:Array = [];
		public	var	activeBoxes:Array = [];
		
		private var imagesByName:Object;

		private	var	quadBatch:QuadBatch;
		private	var	nextAnim:String = "";
		private	var	callback:Function;

		public function Spriter(name:String, data:*, atlas:TextureAtlas = null, entities:Array = null, animations:Array = null)
		{
			super();
			
			this.name = name;
			
			imagesByName = {};
			
			animation = SpriterCache.findAnimation (name);
			
			if (!animation)
			{
				animation = SpriterCache.addAnimation (name, new SpriterAnimation (data, atlas, entities, animations));
			}
			
			quadBatch = new QuadBatch ();
			addChild (quadBatch);
		}
		
		public override function dispose():void
		{
			for (var name:String in imagesByName)
			{
				imagesByName[name].dispose ();
				imagesByName[name] = null;
			}

			quadBatch.dispose();
			removeChildren(0, -1, true);
			
			imagesByName = null;
			
			super.dispose();
		}

		public	function loadEntity (name:String, animations:Array = null):void
		{
			for (var a:int = 0; a < animation.entities.length; a++)
			{
				var	entity:Entity = animation.entities[a] as Entity;
				
				if (entity.name == name && !entity.loaded)
				{
					if (entity.entityData is XML)
						entity.parseXML (animation, animations);
				}
			}
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
		
		public	function hasAnim (animName:String):Boolean
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			for (var a:int = 0; a < entity.animations.length; a++)
			{
				var	anim:Animation = entity.animations[a] as Animation;
				
				if (anim.name == animName && anim.loaded)
				{
					return true;
				}
			}

			return false;
		}
		
		public	function loadAnim (name:String, animName:String):void
		{
			for (var e:int = 0; e < animation.entities.length; e++)
			{
				var	entity:Entity = animation.entities[e] as Entity;
			
				for (var a:int = 0; a < entity.animations.length; a++)
				{
					var	anim:Animation = entity.animations[a] as Animation;
					
					if (anim.name == animName && !anim.loaded)
					{
						anim.parseXML (animation);
					}
				}
			}
		}
		
		public	function playAnim (animName:String, nextAnim:String = "", callback:* = null):void
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			this.nextAnim = nextAnim;
			this.callback = callback;
			
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
		
		public function setCallback (callback:*):void 
		{
			mCallBack = callback
		}
		
		public function advanceTime(time:Number):void 
		{
			if (!visible)
				return;
			
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			var	anim:Animation = entity.animations[currentAnimation] as Animation;
			var	image:Image;
			
			if (anim)
			{
				currentTime += (time * playbackSpeed);
				
				anim.setCurrentTime (currentTime * 1000);
				
				if (!animation.atlas)
					return;
				
				for (var n:String in imagesByName)
				{
					image = imagesByName[n];
					image.visible = false;
				}
				
				activePoints.length = 0;
				activeBoxes.length = 0;
				
				quadBatch.reset();
				
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
							
							image.x = spriteKey.x;
							image.y = spriteKey.y;
							image.scaleX = spriteKey.scaleX;
							image.scaleY = spriteKey.scaleY;
							image.rotation = deg2rad (fixRotation (spriteKey.angle));
							image.visible = true;
							
							quadBatch.addImage(image);
						}
					}
					else if (key is PointTimelineKey)
					{
						var	point:PointTimelineKey = key as PointTimelineKey;
						
						activePoints.push(point);
					}
					else if (key is BoxTimelineKey)
					{
						var	box:BoxTimelineKey = key as BoxTimelineKey;
						
						activeBoxes.push(box);
					}
				}

				if (anim.currentTime >= anim.length)
				{
					if (nextAnim != "")
					{
						playAnim (nextAnim);
					}
					else if (callback != null)
					{
						callback (this);
					}
					else if (anim.loopType == Animation.NO_LOOPING)
					{
						visible = false;						
					}
				}
			}
			
			if (mCallBack)
				mCallBack (this);
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