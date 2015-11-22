package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.AppSettingsProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ChangeScaleRatioCommand extends SimpleCommand implements ICommand
	{
		public function ChangeScaleRatioCommand()
		{
			super();
		}
		
		override public function execute(note:INotification):void {
			
			var appSettingsProxy:AppSettingsProxy = facade.retrieveProxy( AppSettingsProxy.NAME ) as AppSettingsProxy;
			trace( appSettingsProxy );
			appSettingsProxy.scaleRatio = note.getBody() as Number;
		}
		
	}
}