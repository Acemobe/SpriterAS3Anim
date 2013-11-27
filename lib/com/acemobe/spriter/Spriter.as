package com.acemobe.spriter
{
	import com.acemobe.spriter.data.Animation;
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.File;
	import com.acemobe.spriter.data.Folder;
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
		protected var childImages:Vector.<Image>;
		
		public	var	nextAnim:String = "";

		public function Spriter(name:String, data:XML, atlas:TextureAtlas)
		{
			super();
			
			this.name = name;
			
			imagesByName = {};
			childImages = new <Image>[];
			
			animation = SpriterCache.findAnimation(name);
			if (!animation)
			{
				animation = SpriterCache.addAnimation(name, new SpriterAnimation (data, atlas));
			}
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
					
					return;
				}
			}
		}
		
		public function advanceTime(time:Number):void 
		{
			currentTime += time;
			
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			var	anim:Animation = entity.animations[currentAnimation] as Animation;
			
			if (anim)
			{
				anim.setCurrentTime (currentTime * 1000);
				
				removeChildren(0, -1, true);
				
				imagesByName = {};
				childImages.length = 0;
				
				for(var	k:int = 0; k < anim.objectKeys.length; k++)
				{   
					var	key:TimelineKey = anim.objectKeys[k] as TimelineKey;
					
					if (key is SpriteTimelineKey)
					{
						var	spriteKey:SpriteTimelineKey = key as SpriteTimelineKey;
						var	image:Image = getImageByName (spriteKey);
						
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
							
							childImages.push(image);
							addChild(image);
						}
					}
				}
				
				if (nextAnim != "" && anim.currentTime >= anim.length)
				{
					play (nextAnim);
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
			var image:Image
			
			if (key.spriteName)
			{
				image = imagesByName[key.spriteName];
			}
			
			if (!image)
			{
				var	folder:Folder = animation.folders[key.folder] as Folder;
				var	file:File = folder.files[key.file] as File;
				var	name:String = file.name;
				
				var texture:Texture = animation.atlas.getTexture(name);
				if(!texture)
				{
					var	pos:int = name.lastIndexOf("/");
					if (pos != -1)
					{
						name = name.substr(pos + 1);
					}
					
					texture = animation.atlas.getTexture(name); 
				}
				
				if (texture)
				{
					key.spriteName = name;
					image = new Image(texture);
					image.name = name;
					image.color = currentColor;
					imagesByName[name] = image;
					
					image.pivotX = file.pivot_x * file.width;
					image.pivotY = (1 - file.pivot_y) * file.height;
				}
			}
			
			return image;
		}
	}
}