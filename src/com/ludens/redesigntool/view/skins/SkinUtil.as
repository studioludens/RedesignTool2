package com.ludens.redesigntool.view.skins
{
	import com.ludens.redesigntool.view.skins.libraries.*;
	
	public class SkinUtil
	{	
		// sketch item types that have skins
		public static const COMMENT_TYPE	:String = "comment";
		public static const GRAPHIC_TYPE	:String = "graphic";
		public static const DRAWING_TYPE	:String = "drawing";
		
		/**
		 * returns a skin class based on provided skin type and skin name
		 */
		public static function getSkinByTypeAndName( skinType:String, skinName:String ):Class {
			
			var targetSkin		:Class;
			
			// get skin for the targeted skin library type
			if( skinType == SkinUtil.COMMENT_TYPE )
				targetSkin = CommentSkinLibrary.getSkinByName( skinName );
			if( skinType == SkinUtil.DRAWING_TYPE )
				targetSkin = DrawingItemSkinLibrary.getSkinByName( skinName );
			if( skinType == SkinUtil.GRAPHIC_TYPE )
				targetSkin = GraphicSkinLibrary.getSkinByName( skinName );
			
			return targetSkin;
		}
	}
}