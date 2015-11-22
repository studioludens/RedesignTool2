package com.ludens.redesigntool.view.skins.libraries
{
	import com.ludens.redesigntool.view.skins.ISkinLibrary;
	import com.ludens.redesigntool.view.skins.drawing.*;
	
	public class DrawingItemSkinLibrary implements ISkinLibrary
	{
		private static const DEFAULT_SKIN		:Class = SimpleDrawingItemSkin;
		
		public static function getSkinByName( skinName:String ):Class {
			
			return DrawingItemSkinLibrary[skinName];
		}
	}
}