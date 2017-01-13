<?xml version="1.0"?>

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:common="http://sita.aero/common/2/0" xmlns="http://sita.aero/SITA_AirBookRQ/3/0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="modType">
		<xsl:choose>
			<xsl:when test=".//ActionType = 'Create'">
				<xsl:value-of select="5" />
			</xsl:when>
			<xsl:when test=".//ActionType = 'Update'">
				<xsl:value-of select="5" />
			</xsl:when>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">

		<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
			<SOAP-ENV:Header>
				<hal:Config xmlns:hal="http://sita.aero/hal"
					applicationId="HALJavaClient" conversationId="" host="SWS">
				</hal:Config>
			</SOAP-ENV:Header>
			<SOAP-ENV:Body>
				<OTA_AirBookModifyRQ xmlns="http://sita.aero/SITA_AirBookModifyRQ/4/0"
					xmlns:common="http://sita.aero/common/2/0" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
					Target="QAA" TransactionIdentifier="" Version="0">
					<POS>
						<common:Source AgentDutyCode="51" AgentSine="9947/9947A"
							AirlineVendorID="AI" AirportCode="DEL" ERSP_UserID="SECAI/1SEC4AI"
							ISOCountry="AI" PseudoCityCode="WWW101">
							<common:RequestorID ID="98760023" Type="5" />
						</common:Source>
					</POS>
					<AirBookModifyRQ BookingReferenceID="{//Order/OrderID}"
						ModificationType="5">
						<xsl:if test="//Order//Passengers">
							<common:TravelerInfo>
								<xsl:for-each select="//Order//Passengers/Passenger">
									<common:AirTraveler PassengerTypeCode="{.//PTC}">
										<common:PersonName>
											<common:GivenName>
												<xsl:value-of select=".//Name//Given" />
											</common:GivenName>
											<common:Surname>
												<xsl:value-of select=".//Name//Surname" />
											</common:Surname>
										</common:PersonName>
										<common:Email Operation="Add">
											<xsl:value-of select="//Order//EmailContact/Address" />
										</common:Email>
										<common:Email Operation="Delete">
											<xsl:value-of select="//Passengers//EmailContact/Address" />
										</common:Email>
										<common:TravelerRefNumber RPH="{substring-after(./@refs, 'X')}" />
									</common:AirTraveler>
								</xsl:for-each>
							</common:TravelerInfo>
						</xsl:if>
						<xsl:if test="//FlightItem">
							<common:AirItinerary>
								<common:OriginDestinationOptions>
									<xsl:for-each select=".//Flight">
										<common:OriginDestinationOption>
											<common:FlightSegment Status="{.//StatusCode/Code}"
												RPH="{substring-after(./SegmentKey, 'G')}" DepartureDateTime="{concat(.//Departure/Date, 'T', .//Departure/Time, ':00')}">
												<common:DepartureAirport
													LocationCode="{.//Departure/AirportCode}" />
												<common:ArrivalAirport LocationCode="{.//Arrival/AirportCode}" />
												<common:OperatingAirline
													FlightNumber="{.//FlightNumber}" Code="{.//AirlineID}" />
												<common:BookingClassAvails>
													<common:BookingClassAvail
														ResBookDesigStatusCode="NN" ResBookDesigQuantity="1"
														ResBookDesigCode="{.//CabinType/Code}" RPH="{substring-after(./SegmentKey, 'G')}" />
												</common:BookingClassAvails>
											</common:FlightSegment>
										</common:OriginDestinationOption>
									</xsl:for-each>
								</common:OriginDestinationOptions>
							</common:AirItinerary>
						</xsl:if>
					</AirBookModifyRQ>
				</OTA_AirBookModifyRQ>
			</SOAP-ENV:Body>
		</SOAP-ENV:Envelope>
	</xsl:template>
</xsl:stylesheet>

<!-- <POS> <common:Source AgentDutyCode="51" AgentSine="9947/9947A" AirlineVendorID="{.//AgencyID}" 
	AirportCode="{.//DepartureCode[1]}" ISOCountry="{.//AgencyID}" PseudoCityCode="{.//PseudoCity}" 
	ERSP_UserID="SECAI/1SEC4AI" /> <common:RequestorID ID="98760023" Type="5" 
	/> </POS> -->