<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sita="http://www.sita.aero/PTS/fare/2005/12/FlightShopRQ"
	xmlns:ota="http: / www.opentravel.org / OTA /">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="arrivalDateTime"
		select="concat(.//Arrival/Date, 'T', .//Arrival/Time, ':00')" />
	<xsl:variable name="departureDateTime"
		select="concat(.//Departure/Date, 'T', .//Departure/Time, ':00')" />


	<xsl:template name="POSTemp">
		<POS>
			<Source AgentDutyCode="52" AgentSine="9947/*****"
				AirlineVendorID="{.//AgencyID}" AirportCode="{.//DepartureCode[1]}"
				ISOCountry="{.//Party/Sender/TravelAgencySender/AgencyID}"
				PseudoCityCode="{.//PseudoCity}" />
		</POS>
	</xsl:template>

	<xsl:template name="OTATemp">
		<ota:OTA_AirLowFareSearchRQ Version="0.001">
			<ota:POS>
				<ota:Source AirlineVendorID="{.//AgencyID}" AirportCode="{.//Departure/AirportCode}"
					PseudoCityCode="{.//PseudoCity}" />
				<ota:Source>
					<RequestorID Type="7" ID="V1T9s-uRj4K-30mZp-HA5g2" ID_Context="Airfare"/>
				</ota:Source>
				<ota:Source>
					<ota:RequestorID ID="MOBI99" ID_Context="DepartmentCode"
						Type="13" />
				</ota:Source>
			</ota:POS>

			<xsl:for-each select=".//OriginDestination">
				<xsl:variable name="Index">
					<xsl:choose>
						<xsl:when test="position() &gt; 9">
							<xsl:value-of select="position()" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('0', position())" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<ota:OriginDestinationInformation
					RPH="{$Index}">
					<ota:DepartureDateTime>
						<xsl:value-of select="./Departure/Date" />
					</ota:DepartureDateTime>
					<ota:OriginLocation LocationCode="{./Departure/AirportCode}" />
					<ota:DestinationLocation LocationCode="{./Arrival/AirportCode}" />
				</ota:OriginDestinationInformation>
			</xsl:for-each>
			<ota:TravelPreferences>
				<ota:CabinPref Cabin="{.//CabinType/Definition}"
					Preference="Only" />
			</ota:TravelPreferences>
			<ota:TravelerInfoSummary>
				<xsl:for-each select=".//Traveler">
					<ota:AirTravelerAvail>
						<ota:PassengerTypeQuantity Code="{.//PTC}"
							Quantity="{.//PTC/@Quantity}" />
					</ota:AirTravelerAvail>
				</xsl:for-each>
				<ota:PriceRequestInformation
					PricingSource="Both">
					<ota:NegotiatedFareCode Code="MOBI" />
				</ota:PriceRequestInformation>
			</ota:TravelerInfoSummary>
		</ota:OTA_AirLowFareSearchRQ>
	</xsl:template>



	<xsl:template match="/">
		<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
			<soap:Body>
				<sita:SITA_AirfareFlightShopRQ
					xmlns:sita="http://www.sita.aero/PTS/fare/2005/12/FlightShopRQ"
					DirectFlightsOnly="false" EchoToken="SITALABDEMO" Version="0.001"
					xmlns:ota="http://www.opentravel.org/OTA/2003/05" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
					<xsl:call-template name="POSTemp" />
					<xsl:call-template name="OTATemp" />
				</sita:SITA_AirfareFlightShopRQ>
			</soap:Body>
		</soap:Envelope>
	</xsl:template>

</xsl:stylesheet>
