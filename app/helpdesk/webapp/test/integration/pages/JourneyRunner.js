sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/vivo/helpdesk/test/integration/pages/IncidentesList.gen",
	"com/vivo/helpdesk/test/integration/pages/IncidentesObjectPage.gen"
], function (JourneyRunner, IncidentesListGenerated, IncidentesObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/vivo/helpdesk') + '/test/flp.html#app-preview',
        pages: {
			onTheIncidentesListGenerated: IncidentesListGenerated,
			onTheIncidentesObjectPageGenerated: IncidentesObjectPageGenerated
        },
        async: true
    });

    return runner;
});

