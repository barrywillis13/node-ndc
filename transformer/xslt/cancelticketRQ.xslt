<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:n1="http://www.iata.org/IATA/EDIST"
	xmlns="http://sita.aero/SITA_VoidEticket/5/0" >

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<SITA_VoidEticket>
			<TicketingInfo FormAndSerialNumber="{.//n1:TicketDocument/n1:Type/n1:Code}" 
				ResidingDatabase="" AirlineAccountingCode="" />
		</SITA_VoidEticket>
	</xsl:template>

</xsl:stylesheet>