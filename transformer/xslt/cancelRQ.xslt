<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ex="http://exslt.org/dates-and-times"
	xmlns:ns1="http://www.iata.org/IATA/EDIST">

	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
	<SOAP-ENV:Header>
		<hal:Config applicationId="HALJavaClient" conversationId=""
			host="SWS" xmlns:hal="http://sita.aero/hal" />
	</SOAP-ENV:Header>
	<SOAP-ENV:Body>
			
				<OTA_CancelRQ Target="QAA" TransactionIdentifier=""
					Version="0" xmlns="http://sita.aero/SITA_CancelRQ/4/0"
					xmlns:common="http://sita.aero/common/2/0">
					<POS>
						<common:Source AgentDutyCode="51" AgentSine="9947/9947A"
							AirlineVendorID="AI" AirportCode="DEL" ERSP_UserID="SECAI/1SEC4AI"
							ISOCountry="AI" PseudoCityCode="WWW101">
							<common:RequestorID ID="98760023" Type="5" />
						</common:Source>
					</POS>
					<UniqueID ID="{//ns1:OrderID}" Type="15" />
				</OTA_CancelRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
	</xsl:template>

</xsl:stylesheet>





