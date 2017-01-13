<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ex="http://exslt.org/dates-and-times">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="timestamp">
		<xsl:call-template name="Timestamp" />
	</xsl:variable>

	<xsl:template name="Timestamp">
		<xsl:param name="datestr" select="ex:date-time()" />
		<xsl:value-of select="substring($datestr,1,19)" />
	</xsl:template>

	<xsl:template name="POSTemp">
		<POS>
			<Source AirlineVendorID="AI" AirportCode="DEL" PseudoCityCode="{.//PseudoCity}" />
			<Source>
				<RequestorID Type="7" ID="05ueM-RBQ5f-i4D8v-aP4SH"
					ID_Context="Airfare" />
			</Source>
		</POS>
	</xsl:template>

	<xsl:template match="/">
		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<SOAP-ENV:Header>
				<hal:Config xmlns:hal="http://sita.aero/hal"
					applicationId="HALJavaClient" conversationId="000" host="AXI">
					<POS Target="">
						<Source AgentDutyCode="" AgentSine="" AirlineVendorID=""
							AirportCode="" ApplicationType="" BagTagPectab="" CheckinZone=""
							ERSP_UserID="" ISOCountry="" PrintBoardingPassPectab=""
							PseudoCityCode="" />
					</POS>
				</hal:Config>
			</SOAP-ENV:Header>
			<SOAP-ENV:Body>
				<SITA_AirfarePriceRQ Version="0.3"
					xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:Ota="http://www.opentravel.org/OTA/2003/05" xmlns:Sita="http://www.sita.aero/PTS/fare/2005/11/PriceRQ"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
					<OTA_AirPriceRQ Timestamp="$timestamp" Version="2.001"
						xmlns="http://www.opentravel.org/OTA/2003/05">
						<xsl:call-template name="POSTemp" />
						<AirItinerary>
							<OriginDestinationOptions>
								<xsl:for-each select="//Flight">
									<OriginDestinationOption>
										<FlightSegment
											DepartureDateTime="{concat(.//Departure/Date, 'T', .//Departure/Time, ':00')}"
											ArrivalDateTime="{concat(.//Arrival/Date, 'T', .//Arrival/Time, ':00')}"
											FlightNumber="{.//MarketingCarrier/FlightNumber}" RPH="{position()}"
											Status="100" StopQuantity="0">
											<DepartureAirport LocationCode="{.//Departure/AirportCode}" />
											<ArrivalAirport LocationCode="{.//Arrival/AirportCode}" />
											<MarketingAirline Code="{.//MarketingCarrier/AirlineID}" />
										</FlightSegment>
									</OriginDestinationOption>
								</xsl:for-each>
							</OriginDestinationOptions>
						</AirItinerary>
						<TravelerInfoSummary />
					</OTA_AirPriceRQ>
				</SITA_AirfarePriceRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>

	</xsl:template>

</xsl:stylesheet>





