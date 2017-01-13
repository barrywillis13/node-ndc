<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes" />


	<xsl:template match="/">
	
		<SOAP-ENV:Envelope xmlns="http://sita.aero/SITA_AirBookRQ/3/0"
			xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:common="http://sita.aero/common/2/0" xmlns:ota="http://www.opentravel.org/OTA/"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<SOAP-ENV:Header>
				<hal:Config applicationId="HALJavaClient" conversationId=""
					host="SWS" xmlns:hal="http://sita.aero/hal" />
			</SOAP-ENV:Header>
			<SOAP-ENV:Body>
				<ota:SITA_AirDemandTicketRQ Target="QAA"
					Version="0.0" xmlns:common="http://sita.aero/common/1/0"
					xmlns:ota="http://sita.aero/SITA_AirDemandTicketRQ/3/0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xsi:schemaLocation="http://sita.aero/SITA_AirDemandTicketRQ/3/0 SITA_AirDemandTicketRQ.xsd">
					<ota:POS>
						<common:Source AgentDutyCode="51" AgentSine="{//AgentUserID}"
							AirlineVendorID="{//AgentUserID/@Owner}" AirportCode="BOM" ERSP_UserID="SECAI/1SEC4AI"
							ISOCountry="IN" PseudoCityCode="WWW001">
							<common:RequestorID ID="00000011E" Type="5"/>
						</common:Source>
					</ota:POS>
					<ota:DemandTicketDetail>
						<ota:MessageFunction Function="ET" />
						<ota:BookingReferenceID ID="{//BookingReference/ID}" Type="14" />
						<ota:PaymentInfo PaymentType="1" />
						<ota:PassengerName PassengerTypeCode="{//PTC}" RPH="1">
							<common:GivenName><xsl:value-of select="//Given"/></common:GivenName>
							<common:Surname><xsl:value-of select="//Surname"/></common:Surname>
						</ota:PassengerName>
						<ota:TPA_Extensions>
							<ota:TaxProcessing TaxBoxes="1" />
							<ota:PTC_FareBreakdown PricingSource="Published">
								<common:PassengerTypeQuantity Code="{//PTC}" />
								<common:FareBasisCodes>
								<xsl:for-each select="//FareBasisCode">
									<common:FareBasisCode><xsl:value-of select="./Code"/></common:FareBasisCode>
								</xsl:for-each>
								</common:FareBasisCodes>
								<common:PassengerFare>
									<common:BaseFare Amount="{//BaseAmount}" CurrencyCode="{//BaseAmount/@Code}" />
									<common:Taxes>
									<xsl:for-each select="//Taxes/Breakdown/Tax">
										<common:Tax Amount="{./Amount}" CurrencyCode="{./Amount/@Code}"
											TaxCode="{./TaxCode}" />
									</xsl:for-each>
									</common:Taxes>
									<common:UnstructuredFareCalc>LON AI DEL1300.56NUC1300.56END
										ROE0.749672</common:UnstructuredFareCalc>
									<common:TPA_Extensions>
										<common:SITA_PassengerFareExtension>
											<common:AppliedPTCs PTC="{//PTC}" />
										</common:SITA_PassengerFareExtension>
									</common:TPA_Extensions>
								</common:PassengerFare>
							</ota:PTC_FareBreakdown>
						</ota:TPA_Extensions>
					</ota:DemandTicketDetail>
				</ota:SITA_AirDemandTicketRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
	</xsl:template>
</xsl:stylesheet>
