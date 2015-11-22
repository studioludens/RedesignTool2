package com.ludens.redesigntool.controller.commands.startup
{
	import com.ludens.redesigntool.controller.Notifications;
	import com.ludens.redesigntool.model.AppSettingsProxy;
	import com.ludens.redesigntool.model.om.Graphic;
	import com.ludens.redesigntool.view.components.editor.RedesignMediator;
	import com.ludens.redesigntool.view.components.menus.*;
	
	import mx.core.Application;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	

	public class StartupViewCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var app:RedesignTool = note.getBody() as RedesignTool;
			
			// TO BE IMPLEMENTED (CLASSES NEED TO BE CREATED
			//facade.registerMediator( new ApplicationMediator( app ) );
			facade.registerMediator( new RedesignMediator( app.redesignView ) );
			
			// set the scaleRatio based on the initial height of the RedesignView
			var appSettingsProxy:AppSettingsProxy = facade.retrieveProxy( AppSettingsProxy.NAME ) as AppSettingsProxy;
			appSettingsProxy.scaleRatio = app.redesignView.height;
			
			// get the info from the flash vars
			appSettingsProxy.sessionId  = Application.application.parameters.session_id;
			appSettingsProxy.path		= Application.application.parameters.path;
			appSettingsProxy.ixItem		= Application.application.parameters.ixItem;
			appSettingsProxy.imgIndex	= Application.application.parameters.imgIndex;
			
			// test menu	
			facade.registerMediator( new TestMenuMediator( app.testMenu ) );
			
			// export menu
			facade.registerMediator( new ExportMenuMediator( app.exportMenu ) );
			
			
			// add start image if provided by FlashVars
			var sourceUrl	:String = Application.application.parameters.sourceUrl;
			var sourceWidth	:Number = Application.application.parameters.sourceWidth;
			var sourceHeight:Number = Application.application.parameters.sourceHeight;
			
			if( sourceUrl != null ) {
				sendNotification( Notifications.ADD_ITEM, { itemClass: Graphic,
															itemData: { url: sourceUrl,
																		width: sourceWidth,
																		height: sourceHeight } 
														  } );
			}
		}
	}
}