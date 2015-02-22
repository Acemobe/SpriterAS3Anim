package com.acemobe.spriter
{
	import com.acemobe.spriter.data.Animation;
	import com.acemobe.spriter.data.BoxTimelineKey;
	import com.acemobe.spriter.data.Entity;
	import com.acemobe.spriter.data.Folder;
	import com.acemobe.spriter.data.PointTimelineKey;
	import com.acemobe.spriter.data.SpriteTimelineKey;
	import com.acemobe.spriter.data.TimelineKey;
	
	import flash.utils.Dictionary;
	
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
		
		private	var	mFrameCallBack:Function = null;
		private	var	mCompleteCallback:Function = null;
		
		public	var	playbackSpeed:Number = 1;
		public	var	activePoints:Array = [];
		public	var	activeBoxes:Array = [];
		
		private var imagesByName:Object;
		private var colorByName:Object;

		private	var	quadBatch:QuadBatch;
		private	var	nextAnim:String = "";

		public function Spriter(name:String, animName:String, data:* = null, entities:Array = null, animations:Array = null)
		{
			super();
			
			this.name = name;
			
			imagesByName = {};
			colorByName = {};
			
			animation = SpriterCache.findAnimation (animName);
			
			if (!animation)
			{
				animation = SpriterCache.addAnimation (animName, new SpriterAnimation (animName, data, entities, animations));
			}
			
			quadBatch = new QuadBatch ();
			addChild (quadBatch);
		}
		
		public	function setAnimation (name:String):void
		{
			animation = SpriterCache.findAnimation (name);
		}
		
		public override function dispose():void
		{
			for (var name:String in imagesByName)
			{
				imagesByName[name].dispose ();
				imagesByName[name] = null;
			}
			
			for (name in colorByName)
			{
				colorByName[name] = null;
			}
			
			quadBatch.dispose();
			removeChildren(0, -1, true);
			
			imagesByName = null;
			colorByName = null;
			
			super.dispose();
		}
		
		public	function clearImages ():void
		{
			for (var name:String in imagesByName)
			{
				imagesByName[name].dispose ();
				imagesByName[name] = null;
			}
			
			imagesByName = [];
		}

		public	function clearMapping ():void
		{
			mTextureMapping = new Dictionary ();
		}
		
		public	function getAnimationName ():String
		{
			return animation.name;
		}
		
		public	function get folders ():Array
		{
			return animation.folders;
		}
		
		public	function getfolder (name:String):Folder
		{
			for (var a:int = 0; a < animation.folders.length; a++)
			{
				var	folder:Folder = animation.folders[a];
				
				if (folder.name == name)
				{
					return folder; 
				}
			}
			
			return null;
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
		
		public	function setEntityTextureAtlas (atlas:TextureAtlas):void
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			if (entity)
			{
				entity.atlas = atlas;
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
		
		public	function playAnim (animName:String, nextAnim:String = "", callback:* = null, force:Boolean = false):void
		{
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			this.nextAnim = nextAnim;
			mCompleteCallback = callback;
			
			for (var a:int = 0; a < entity.animations.length; a++)
			{
				var	anim:Animation = entity.animations[a] as Animation;
				
				if (anim.name == animName)
				{
					if (currentAnimation != a || force)
					{
						currentAnimation = a;
						currentTime = 0;
					}
					else if (anim.currentTime >= anim.length)
					{
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
		
		public function setFrameCallback (callback:*):void 
		{
			mFrameCallBack = callback
		}
		
		public function advanceTime(time:Number):void 
		{
			if (!visible)
				return;
			
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			
			if (!entity.atlas)
				return;

			var	anim:Animation = entity.animations[currentAnimation] as Animation;
			var	image:Image;
			
			if (anim)
			{
				currentTime += (time * playbackSpeed);
				
				anim.setCurrentTime (currentTime * 1000);
				
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
								image.pivotX = spriteKey.pivot_x * spriteKey.fileRef.width;
								image.pivotY = (1 - spriteKey.pivot_y) * spriteKey.fileRef.height;
							}
							
							image.x = spriteKey.x;
							image.y = spriteKey.y;
							image.color = colorByName[spriteKey.spriteName];
							image.scaleX = spriteKey.scaleX;
							image.scaleY = spriteKey.scaleY;
							image.rotation = deg2rad (fixRotation (spriteKey.angle));
							image.visible = true;
							image.alpha = spriteKey.a;

							quadBatch.addImage(image);
							
							if (colorByName[spriteKey.spriteName] != 0xffffff)
							{
//								if (texture && (quad.tinted|| parentAlpha != 1.0))
//									mTinted = true;
								
								quadBatch.setQuadColor (quadBatch.numQuads - 1, colorByName[spriteKey.spriteName]);
							}
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
					
					if (mCompleteCallback != null)
					{
						mCompleteCallback (this);
					}
					
					if (anim.loopType == Animation.NO_LOOPING)
					{
						visible = false;						
					}
				}
				else if (anim.looped && 
					(nextAnim != "" || mCompleteCallback != null))
				{
					if (nextAnim)
					{
						playAnim (nextAnim);
					}
					
					if (mCompleteCallback)
					{
						mCompleteCallback (this);
					}
				}
			}
			
			if (mFrameCallBack)
				mFrameCallBack (this);
		}
		
		public	static function fixRotation(rotation:Number):Number 
		{
			while (rotation < 0)
			{
				rotation += 360;
			}
			
			while (rotation >= 360)
			{
				rotation -= 360;
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
				colorByName[name].color = value;
			}
			
			currentColor = value;
		}
		
		public	function setImageColor (image:String, value:Number):void
		{
			colorByName[image] = value;
			
			if (imagesByName[image])
			{
				imagesByName[image].color = value;
			}
		}
		
		public	var		mTextureMapping:Dictionary = new Dictionary ();
		
		protected function getImageByName(key:SpriteTimelineKey):Image
		{
			if (imagesByName[key.spriteName])
			{
				return imagesByName[key.spriteName];
			}
			
			var	spriteName:String = key.spriteName;
			var	spriteName2:String = key.spriteName2;

			if (mTextureMapping[key.spriteName])
			{
				spriteName = mTextureMapping[key.spriteName];
				
				var	pos:int = spriteName.lastIndexOf("/");
				if (pos != -1)
				{
					spriteName2 = spriteName.substr(pos + 1);
				}
			}
			
			if (mTextureMapping[key.folderRef.name])
			{
				spriteName = mTextureMapping[key.folderRef.name];
				
				pos = spriteName.lastIndexOf("/");
				if (pos != -1)
				{
					spriteName2 = spriteName.substr(pos + 1);
				}
			}
			
			var image:Image;
			var	entity:Entity = animation.entities[currentEntity] as Entity;
			var texture:Texture = entity.atlas.getTexture(spriteName);
			
			if(!texture)
			{
				texture = entity.atlas.getTexture(spriteName2); 
			}
			
			if (texture)
			{
				imagesByName[key.spriteName] = image = new Image(texture);
				image.name = key.spriteName;
				image.pivotX = key.fileRef.pivot_x * key.fileRef.width;
				image.pivotY = (1 - key.fileRef.pivot_y) * key.fileRef.height;

				if (!colorByName[key.spriteName])
				{
					colorByName[key.spriteName] = image.color = currentColor;
				}
			}
			else
			{
//				trace ("Missing texture: " + spriteName2);
			}
			
			return image;
		}
	}
}