<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:common="http://sita.aero/common/1/0" xmlns="http://sita.aero/SITA_AirBookRQ/3/0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="passengerCount" select="count(//Passenger)" />

	<xsl:template name="POSTemp">
		<POS>
			<common:Source AgentDutyCode="51" AgentSine="9947/9947A"
				AirlineVendorID="{.//AgencyID}" AirportCode="{.//DepartureCode[1]}"
				ISOCountry="{.//AgencyID}"
				PseudoCityCode="{.//PseudoCity}" ERSP_UserID="SECAI/1SEC4AI"/>
				<common:RequestorID ID="98760023" Type="5"/>
		</POS>
	</xsl:template>

	<xsl:template name="AirItineraryTemp">
		<common:OriginDestinationOptions>
			<xsl:for-each select=".//FlightSegment">
				<common:OriginDestinationOption
					RefNumber="{position()}">
					<common:FlightSegment FlightNumber="{.//FlightNumber}"
						DepartureDateTime="{concat(.//Departure/Date, 'T', .//Departure/Time, ':00')}"
						ArrivalDateTime="{concat(.//Arrival/Date, 'T', .//Arrival/Time, ':00')}"
						NumberInParty="{$passengerCount}" RPH="{position()}">
						<common:DepartureAirport LocationCode="{.//Departure/AirportCode}" />
						<common:ArrivalAirport LocationCode="{.//Arrival/AirportCode}" />
						<common:OperatingAirline Code="{.//OperatingCarrier/AirlineID}"
							FlightNumber="{.//OperatingCarrier/FlightNumber}" />
						<common:MarketingAirline Code="{.//MarketingCarrier/AirlineID}" />
						<common:BookingClassAvails>
							<common:BookingClassAvail
								ResBookDesigQuantity="{$passengerCount}" RPH="{position()}"
								ResBookDesigCode="Y" />
						</common:BookingClassAvails>
					</common:FlightSegment>
				</common:OriginDestinationOption>
			</xsl:for-each>
		</common:OriginDestinationOptions>
	</xsl:template>

	<xsl:template name="TravelerInfoTemp">
		<TravelerInfo>
			<xsl:for-each select=".//Passengers/Passenger">
				<common:AirTraveler PassengerTypeCode="{./PTC}">
					<common:PersonName>
						<common:NamePrefix></common:NamePrefix>
						<common:GivenName>
							<xsl:value-of select=".//Given" />
						</common:GivenName>
						<common:Surname>
							<xsl:value-of select=".//Surname" />
						</common:Surname>
					</common:PersonName>
					<common:Telephone PhoneLocationType="7" PIN="a"
						PhoneTechType="1" PhoneNumber="{.//PhoneContact/Number}" />
					<common:Email>
						<xsl:value-of select=".//EmailContact" />
					</common:Email>
					<common:TravelerRefNumber RPH="{position()}" />
				</common:AirTraveler>
			</xsl:for-each>
			<!-- <common:SpecialReqDetails> <common:SeatRequests> <common:SeatRequest 
				SeatNumber="16A" FlightRefNumberRPHList="1 2" TravelerRefNumberRPHList="1" 
				/> <common:SeatRequest SeatNumber="16C" FlightRefNumberRPHList="1 2" TravelerRefNumberRPHList="2" 
				/> </common:SeatRequests> <common:Remarks> <common:Remark>Z/SRI Exempt</common:Remark> 
				</common:Remarks> </common:SpecialReqDetails> -->
		</TravelerInfo>
	</xsl:template>

	<xsl:template match="/">
		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<SOAP-ENV:Header>
				<hal:Config xmlns:hal="http://sita.aero/hal"
					applicationId="HALJavaClient" conversationId="" host="SWS">
				</hal:Config>
			</SOAP-ENV:Header>
			<SOAP-ENV:Body>
				<OTA_AirBookRQ Version="0.0" Target="QAB"
					xsi:schemaLocation="http://sita.aero/SITA_AirBookRQ/4/0 SITA_AirBookRQ.xsd"
					xmlns="http://sita.aero/SITA_AirBookRQ/3/0" xmlns:common="http://sita.aero/common/1/0"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
					<xsl:call-template name="POSTemp" />
					<xsl:call-template name="AirItineraryTemp" />
					<xsl:call-template name="TravelerInfoTemp" />
				</OTA_AirBookRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
	</xsl:template>

</xsl:stylesheet>