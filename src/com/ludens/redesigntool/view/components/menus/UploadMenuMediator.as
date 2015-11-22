package com.ludens.redesigntool.view.components.menus
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.DataLoadedEvent;
	import com.ludens.redesigntool.model.AppSettingsProxy;
	import com.ludens.redesigntool.model.om.Graphic;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class UploadMenuMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "UploadMenuMediator";
		
		public function UploadMenuMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
			
			view.addEventListener( DataLoadedEvent.UPLOADED_IMAGE, sendAddImageNotification );
			view.uploadURL = AppSettingsProxy.IMAGE_UPLOAD_PATH;
			
		}
		
		override public function getMediatorName():String
		{
			//TODO: implement function
			return NAME;
		}
		
		public function get view():UploadMenu {
			return viewComponent as UploadMenu;
		}
		
		
		
		override public function listNotificationInterests():Array
		{
			//TODO: implement function
			
			var interests:Array = [  ];
			
			return interests;
			
		}
		
		override public function handleNotification(notification:INotification):void
		{
			//TODO: implement function
		}
		
		public function sendAddImageNotification(e:DataLoadedEvent):void {
			
			sendNotification( Notifications.ADD_ITEM, { 
														itemClass: Graphic, 
														itemData: {
															url: e.imageUrl,
															width: e.imageWidth,
															height: e.imageHeight
														} 
													   } );
			
		}
		
		
		
	}
}