<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
	xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="exsl ex ota"
	xmlns:ota="http://www.opentravel.org/OTA/2003/05" xmlns:common="http://sita.aero/common/2/0"
	xmlns="http://www.iata.org/IATA/EDIST" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:output method="xml" indent="yes" />

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- G L O B A L - V A R I A B L E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:variable name="owner" select=".//common:OperatingAirline[1]/@Code" />

	<xsl:variable name="timestamp">
		<xsl:call-template name="Timestamp" />
	</xsl:variable>

	<xsl:variable name="PassengerNo" select=".//common:TravelerRefNumber/@RPH" />

	<xsl:variable name="BookingRefID" select="//@BookingReferenceID" />

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- F U N C T I O N - T E M P L A T E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template name="Timestamp">
		<xsl:param name="datestr" select="ex:date-time()" />
		<xsl:value-of select="substring($datestr,1,19)" />
	</xsl:template>

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- E L E M E N T - T E M P L A T E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template name="FlightSegmentListTemp">
		<FlightSegmentList>
			<xsl:for-each select=".//common:FlightSegment">
				<FlightSegment SegmentKey="{concat('SEG', ./@RPH)}">
					<Departure>
						<AirportCode>
							<xsl:value-of select="./common:DepartureAirport/@LocationCode" />
						</AirportCode>
						<Date>
							<xsl:value-of select="substring(./@DepartureDateTime, 1, 10)" />
						</Date>
						<Time>
							<xsl:value-of select="substring(./@DepartureDateTime, 12, 5)" />
						</Time>
						<!-- <AirportName></AirportName> -->
					</Departure>
					<Arrival>
						<AirportCode>
							<xsl:value-of select=".//common:ArrivalAirport/@LocationCode" />
						</AirportCode>
						<Date>
							<xsl:value-of select="substring(./@ArrivalDateTime, 1, 10)" />
						</Date>
						<Time>
							<xsl:value-of select="substring(./@ArrivalDateTime, 12, 5)" />
						</Time>
						<!-- <AirportName></AirportName> -->
					</Arrival>
					<!-- <OperatingCarrier> <AirlineID> <xsl:value-of select=".//common:OperatingAirline/@Code" 
						/> </AirlineID> <Name/> <FlightNumber> <xsl:value-of select="./@FlightNumber" 
						/> </FlightNumber> </OperatingCarrier> -->
					<MarketingCarrier>
						<AirlineID>
							<xsl:value-of select=".//common:OperatingAirline/@Code" />
						</AirlineID>
						<Name />
						<FlightNumber>
							<xsl:value-of select="./@FlightNumber" />
						</FlightNumber>
					</MarketingCarrier>
					<!-- <FlightDetail> -->
					<!-- <FlightDuration> -->
					<!-- <Value></Value> -->
					<!-- </FlightDuration> -->
					<!-- </FlightDetail> -->
				</FlightSegment>
			</xsl:for-each>
		</FlightSegmentList>
	</xsl:template>

	<xsl:template name="FlightListTemp">
		<FlightList>
			<xsl:for-each select=".//common:OriginDestinationOption">
				<Flight FlightKey="{concat('FL', position())}">
					<SegmentReferences>
						<xsl:value-of select="concat('SEG', position())" />
					</SegmentReferences>
				</Flight>
			</xsl:for-each>
		</FlightList>
	</xsl:template>

	<xsl:template name="OriginDestinationTemp">
		<OriginDestinationList>
			<xsl:for-each select=".//common:FlightSegment">
				<xsl:variable name="index" select="position()" />
				<OriginDestination OriginDestinationKey="{concat('OD',position())}">
					<DepartureCode>
						<xsl:value-of select="./common:DepartureAirport/@LocationCode" />
					</DepartureCode>
					<ArrivalCode>
						<xsl:value-of select="./common:ArrivalAirport/@LocationCode" />
					</ArrivalCode>
					<FlightReferences>
						<xsl:value-of select="concat('FL', position())" />
					</FlightReferences>
				</OriginDestination>
			</xsl:for-each>
		</OriginDestinationList>
	</xsl:template>

	<xsl:template name="OrderTemp">
		<Order>
			<OrderID Owner="{$owner}">
				<xsl:value-of select="$BookingRefID" />
			</OrderID>
			<BookingReferences>
				<BookingReference>
					<ID>
						<xsl:value-of select="$BookingRefID" />
					</ID>
					<AirlineID>
						<xsl:value-of select="$owner" />
					</AirlineID>
				</BookingReference>
			</BookingReferences>
			<OrderItems>
				<xsl:for-each select=".//common:AirTraveler">
					<OrderItem>
						<xsl:variable name="OrderID"
							select="concat(.//common:TravelerRefNumber/@RPH, '#M#', generate-id(.))" />
						<xsl:variable name="index" select="position()" />
						<OrderItemID Owner="{$owner}">
							<xsl:value-of select="$OrderID" />
						</OrderItemID>
						<FlightItem>
							<xsl:for-each select="//common:FlightSegment">
								<OriginDestination>
									<Flight refs="{concat('SEG', position())}">
										<Departure>
											<AirportCode>
												<xsl:value-of select=".//common:DepartureAirport/@LocationCode" />
											</AirportCode>
											<Date>
												<xsl:value-of select="substring(.//@DepartureDateTime, 1, 10)" />
											</Date>
										</Departure>
										<Arrival>
											<AirportCode>
												<xsl:value-of select=".//common:ArrivalAirport/@LocationCode" />
											</AirportCode>
										</Arrival>
										<MarketingCarrier>
											<AirlineID>
												<xsl:value-of select=".//common:OperatingAirline/@Code" />
											</AirlineID>
											<Name />
											<FlightNumber>
												<xsl:value-of select="..//common:FlightSegment/@FlightNumber" />
											</FlightNumber>
										</MarketingCarrier>
										<!-- <OperatingCarrier> <AirlineID> <xsl:value-of select=".//common:OperatingAirline/@Code" 
											/> </AirlineID> </OperatingCarrier> -->
									</Flight>
								</OriginDestination>
							</xsl:for-each>
						</FlightItem>
						<Associations>
							<Passengers>
								<PassengerReferences>
									<xsl:value-of select="concat('PAX', $index)" />
								</PassengerReferences>
							</Passengers>
						</Associations>
					</OrderItem>
				</xsl:for-each>
			</OrderItems>

		</Order>

	</xsl:template>

	<xsl:template name="PassengersTemp">
		<Passengers>
			<xsl:for-each select=".//common:AirTraveler">
				<xsl:variable name="profileID" select="generate-id(.)" />
				<Passenger ObjectKey="{concat('PAX', position())}">
					<PTC Quantity="1">
						<xsl:value-of select="./@PassengerTypeCode " />
					</PTC>
					<!-- <ResidenceCode></ResidenceCode> -->
					<xsl:if test="./@BirthDate ">
						<Age>
							<BirthDate>
								<xsl:value-of select="./@BirthDate" />
							</BirthDate>
						</Age>
					</xsl:if>
					<Name>
						<!-- <xsl:if test=".//common:PersonName/common:NamePrefix"> -->
						<!-- <NamePrefix> -->
						<!-- <xsl:value-of select="./common:PersonName/common:NamePrefix" /> -->
						<!-- </NamePrefix> -->
						<!-- </xsl:if> -->
						<Surname>
							<xsl:value-of select="./common:PersonName/common:Surname" />
						</Surname>
						<Given>
							<xsl:value-of select="./common:PersonName/common:GivenName" />
						</Given>
						<xsl:if test="./common:PersonName/common:MiddleName">
							<Middle>
								<xsl:value-of select="./common:PersonName/common:MiddleName" />
							</Middle>
						</xsl:if>

					</Name>
					<ProfileID>
						<xsl:value-of select="$profileID" />
					</ProfileID>
					<Contacts>
						<xsl:if test="./common:Address">
							<Contact>
								<AddressContact>
									<Street></Street>
									<PostalCode></PostalCode>
									<CountryCode></CountryCode>
								</AddressContact>
							</Contact>
						</xsl:if>
						<xsl:if test="./common:Email">
							<Contact>
								<EmailContact>
									<Address>
										<xsl:value-of select="./common:Email" />
									</Address>
								</EmailContact>
							</Contact>
						</xsl:if>
						<xsl:if test="./common:Telephone">
							<Contact>
								<PhoneContact>
									<!-- <Application></Application> -->
									<Number>
										<xsl:value-of select="./common:Telephone/@PhoneNumber " />
									</Number>
								</PhoneContact>
							</Contact>
						</xsl:if>
					</Contacts>
				</Passenger>
			</xsl:for-each>
		</Passengers>
	</xsl:template>

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- M A I N - T E M P L A T E -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//common:Error">
				<env:Envelope>
					<env:Body>
						<env:Fault>
							<faultstring>
								<xsl:value-of select="." />
							</faultstring>
							<!-- <faultstring><xsl:value-of select="./env:faultstring" /></faultstring> -->
						</env:Fault>
					</env:Body>
				</env:Envelope>
			</xsl:when>
			<xsl:otherwise>
				<OrderViewRS TimeStamp="{$timestamp}" Version="15.2"
					xmlns="http://www.iata.org/IATA/EDIST" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					xmlns:xsd="http://www.w3.org/2001/XMLSchema">

					<Document>
						<Name>
							<xsl:value-of select="$owner" />
						</Name>
						<ReferenceVersion>1.0</ReferenceVersion>
					</Document>
					<Success />
					<Response>
						<OrderViewProcessing />
						<xsl:call-template name="PassengersTemp" />

						<xsl:call-template name="OrderTemp" />
						<DataList>
							<xsl:call-template name="FlightSegmentListTemp" />
							<xsl:call-template name="FlightListTemp" />
							<xsl:call-template name="OriginDestinationTemp" />
						</DataList>
						<Metadata>
							<Other>
								<OtherMetadata>
									<CurrencyMetadatas>
										<CurrencyMetadata MetadataKey="ID1">
											<Decimals>2</Decimals>
										</CurrencyMetadata>
									</CurrencyMetadatas>
								</OtherMetadata>
							</Other>
						</Metadata>
					</Response>
				</OrderViewRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>