package com.ludens.redesigntool.controller.commands.startup
{
	import com.ludens.redesigntool.model.AppSettingsProxy;
	import com.ludens.redesigntool.model.DrawingSettingsProxy;
	import com.ludens.redesigntool.model.KeyboardProxy;
	import com.ludens.redesigntool.model.RedesignProxy;
	import com.ludens.redesigntool.model.SelectionProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;

	public class StartupModelCommand extends SimpleCommand
	{
		public function StartupModelCommand()
		{
			super();
		}
		
		override public function execute(note:INotification):void
		{
			facade.registerProxy( new RedesignProxy() );
			facade.registerProxy( new SelectionProxy() );
			
			facade.registerProxy( new AppSettingsProxy() );
			facade.registerProxy( new DrawingSettingsProxy() );
			
			facade.registerProxy( new CommandsHistoryProxy() );
			facade.registerProxy( new KeyboardProxy() );
			
			// storing data about user preferences or so
			//facade.registerProxy( new ApplicationSettings() );
		}	
	}
}