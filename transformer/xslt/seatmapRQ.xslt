<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >

	<xsl:output method="xml" indent="yes" />

	<xsl:template name="POSTemp">
		<POS>
			<Source AgentDutyCode="52" AgentSine="9947/9947A" AirlineVendorID="AI" AirportCode="DEL" ERSP_UserID="SECAI/1SEC4AI"
				ISOCountry="{.//Party/Sender/TravelAgencySender/AgencyID}" PseudoCityCode="{.//PseudoCity}" />
				<common:RequestorID ID="" Type="" />
		</POS>
	</xsl:template>
	
	<xsl:template match="/">
		<SeatAvailabilityRQ>
			<xsl:call-template name="POSTemp" />
			<SeatMapRequests>
				<SeatMapRequest>
					<FlightSegmentInfo DepartureDateTime="{concat(.//Departure/Date, 'T', .//Departure/Time, ':00')}" FlightNumber="{.//OperatingCarrier/FlightNumber}">
						<common:DepartureAirport LocationCode="{.//OriginDestinationList/OriginDestination/DepartureCode}" />
						<common:ArrivalAirport LocationCode="{.//OriginDestinationList/OriginDestination/ArrivalCode}" />
						<common:MarketingAirline Code="{.//FlightSegment/MarketingCarrier/AirlineID}" />
					</FlightSegmentInfo>
					<SeatDetails>
						<ClassCabin CabinType="{.//FlightSegment/ClassOfService/Code}" />
					</SeatDetails>
				</SeatMapRequest>
			</SeatMapRequests>
		</SeatAvailabilityRQ>
	</xsl:template>

</xsl:stylesheet>