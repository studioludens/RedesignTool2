package com.ludens.redesigntool.controller.commands
{
	import com.ludens.redesigntool.model.DrawingSettingsProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ChangeDrawingSettingsCommand extends SimpleCommand implements ICommand
	{
		public function ChangeDrawingSettingsCommand()
		{
			super();
		}
		
		override public function execute(note:INotification):void {
			
			var proxy:DrawingSettingsProxy = facade.retrieveProxy( DrawingSettingsProxy.NAME ) as DrawingSettingsProxy;
			
			for each( var property:Object in note.getBody() ) {
				
				if( proxy.hasOwnProperty( property.propertyName ) )
					proxy[ property.propertyName ] = property.newValue;
			}
		}
		
	}
}