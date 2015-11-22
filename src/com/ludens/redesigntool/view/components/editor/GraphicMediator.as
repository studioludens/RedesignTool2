package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.controller.Notifications;
	
	import org.puremvc.as3.interfaces.*;
	
	public class GraphicMediator extends SketchItemMediator implements IMediator
	{
		public static const NAME:String = "GraphicMediator";
		
		private var graphicView:GraphicView;
		
		public function GraphicMediator(viewComponent:Object=null)
		{
			graphicView = (viewComponent as GraphicView);
			
			super(null, viewComponent);
		}
		
		/**
		 * Gets view component.
		 * This is a CommentView object.
		 */
		override public function getViewComponent():Object
		{
			return viewComponent;
		}
		
		/**
		 * Returns a list of notifications the CommentMediator is interested in.
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push( Notifications.GRAPHICS_EDITED );
			
			return interests; 
		}
		
		/**
		 * This function is called when a notification is sent to it
		 */
		override public function handleNotification(notification:INotification):void
		{
			super.handleNotification(notification);
			
			switch (notification.getName()) {
				
				// if notification is EDIT_COMMENT notification
				case Notifications.GRAPHICS_EDITED:
					// get data objects array from notification
					
					break;
			}
		}
		
	}
}