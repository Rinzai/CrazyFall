package com.taverna.capuchin.helpers
{
	import flash.system.Capabilities;
	
	import eu.alebianco.air.extensions.analytics.Analytics;
	import eu.alebianco.air.extensions.analytics.api.ITracker;

	public class AnalyticsHelper
	{
		private static var tracker:ITracker;
		
		public static function init():void
		{
			if(Analytics.isSupported() && Capabilities.isDebugger == false)
			{
				var analytics:Analytics = Analytics.getInstance();
				tracker = analytics.getTracker("UA-11424184-6");
			}
		}
		
		public static function trackView(viewName:String):void
		{
			if(tracker)
			{
				tracker.buildView(viewName).track();
			}
		}
	
		public static function trackEvent(param0:String, param1:String):void
		{
			if(tracker)
			{
				tracker.buildEvent( param0, param1 ).track();
			}
		}
	}
}