package com.ludens.redesigntool.view.components.menus
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.events.SaveEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.interfaces.INotification;

	public class ExportMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ExportMenuMediator";
		
		public function ExportMenuMediator(viewComponent:Object=null)
		{
			//TODO: implement function
			super(NAME, viewComponent);
			
			
			view.addEventListener( SaveEvent.SAVE, sendSaveNotification );
		}
		
		override public function getMediatorName():String
		{
			//TODO: implement function
			return NAME;
		}
		
		public function get view():ExportMenu {
			return viewComponent as ExportMenu;
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
		
		public function sendSaveNotification(e:SaveEvent):void {
			
			
			sendNotification( Notifications.SAVE );
			
		}
		
		
	}
}