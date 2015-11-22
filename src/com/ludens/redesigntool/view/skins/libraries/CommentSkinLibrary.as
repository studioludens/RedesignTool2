package com.ludens.redesigntool.view.skins.libraries
{
	import com.ludens.redesigntool.view.skins.ISkinLibrary;
	import com.ludens.redesigntool.view.skins.comment.*;
	
	public class CommentSkinLibrary implements ISkinLibrary
	{
		private static const DEFAULT_SKIN	:Class = NoteCommentSkin;
		private static const SIMPLE_SKIN	:Class = SimpleCommentSkin;
		
		public static function getSkinByName( skinName:String ):Class {
			
			return CommentSkinLibrary[skinName];
		}
	}
}