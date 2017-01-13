<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://sita.aero/SITA_AirBookRQ/3/0"
			xmlns:common="http://sita.aero/common/2/0" xmlns:ota="http://www.opentravel.org/OTA/">
			<SOAP-ENV:Header>
				<hal:Config xmlns:hal="http://sita.aero/hal" host="SWS"
					conversationId="" applicationId="HALJavaClient" />
			</SOAP-ENV:Header>
			<SOAP-ENV:Body>
				<OTA_ReadRQ Version="0.0" Target="QAA"
					xmlns:common="http://sita.aero/common/1/0" xmlns="http://sita.aero/SITA_ReadRQ/3/0"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://sita.aero/SITA_ReadRQ/3/0 SITA_ReadRQ.xsd">

					<POS>
						<Source AgentDutyCode="51" AgentSine="9947/9947A"
							AirlineVendorID="AI" AirportCode="DEL" ERSP_UserID="SECAI/1SEC4AI"
							ISOCountry="{.//Party/Sender/TravelAgencySender/AgencyID}"
							PseudoCityCode="{.//PseudoCity}" />
						<RequestorID Type="5" ID="98760023" />
					</POS>

					<UniqueID ID="{.//Query/Filters/OrderID}" Type="0" />

				</OTA_ReadRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
	</xsl:template>

</xsl:stylesheet>