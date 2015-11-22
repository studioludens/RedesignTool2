package com.ludens.redesigntool.view.components.editor
{
	import com.ludens.redesigntool.controller.Notifications;
	
	import org.puremvc.as3.interfaces.*;

	/**
	 * Mediator for the CommentView
	 */
	public class CommentMediator extends SketchItemMediator implements IMediator
	{
		public static const NAME:String = "CommentMediator";
		
		// viewComponent
		private var commentView:CommentView;
		
		
		//--------------------------------------------------------------------------
		//
		// 	Constructor
		//
	    //--------------------------------------------------------------------------
		
		public function CommentMediator(viewComponent:Object=null)
		{
			commentView = (viewComponent as CommentView);
			
			super(null, viewComponent);
			
			
			
		}
		
		//--------------------------------------------------------------------------
	    //
	   	//  Public  methods
	  	//
		//--------------------------------------------------------------------------
		
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
			interests.push( Notifications.COMMENTS_EDITED );
			
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
				case Notifications.COMMENTS_EDITED:
					// get data objects array from notification
					var dataArray	:Array = (notification.getBody() as Array);
					// get data object from array with corresponding ID 
					var data:Object = getDataWithMatchingId( dataArray );
					// if a data object was found...
					if( data != null )
						// ... set commentView data to match it
						commentView.data = data;
					break;
			}
		}
	}
}