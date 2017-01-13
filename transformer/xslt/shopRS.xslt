<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
	xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="exsl ex sita ota"
	xmlns:sita="http://www.sita.aero/PTS/fare/2005/12/FlightShopRS"
	xmlns:ota="http://www.opentravel.org/OTA/2003/05" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:output method="xml" indent="yes" />


	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- G L O B A L - V A R I A B L E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:key name="priceClassKey" match="sita:FareInfo" use="sita:FareReference" />

	<xsl:variable name="owner" select=".//sita:MarketingAirline[1]/@Code" />

	<xsl:variable name="journeyCount" select="count(.//sita:JourneyPriceOption)" />

	<xsl:variable name="uniquePriceClasses">
		<xsl:for-each
			select=".//sita:FareInfo[generate-id()=generate-id(key('priceClassKey',sita:FareReference)[1])]">
			<PriceClass id="{concat('PC', position())}">
				<xsl:copy-of select="."></xsl:copy-of>
			</PriceClass>
		</xsl:for-each>
	</xsl:variable>


	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- F U N C T I O N - T E M P L A T E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template name="lookupFlightKey">
		<xsl:param name="rph" />
		<xsl:for-each select="//sita:AvailJourneyOption">
			<xsl:if test="$rph = .//@RPH">
				<xsl:value-of select="concat('FL', position(), ' ')" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="lookupSegKeys">
		<xsl:param name="rph" />
		<xsl:choose>
			<xsl:when test="string-length($rph)+1 = 4">
				<xsl:for-each select="//sita:Flight">
					<xsl:if test="$rph = substring(.//@RPH, 1, 4)">

						<xsl:value-of select="concat('SEG', position(), ' ')" />
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//sita:Flight">
					<xsl:if test="$rph = .//@RPH">

						<xsl:value-of select="concat('SEG', position(), ' ')" />
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Timestamp">
		<xsl:param name="datestr" select="ex:date-time()" />
		<xsl:variable name="date" select="substring($datestr,1,11)" />
		<xsl:variable name="hour" select="substring($datestr,12,2)" />
		<xsl:variable name="hourplus1">
			<xsl:choose>
				<xsl:when test="$hour = 23">
					<xsl:value-of select="00" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$hour + 1" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="monthday" select="substring($datestr,14,6)" />
		<xsl:value-of select="concat($date, $hourplus1, $monthday)" />
	</xsl:template>

	<xsl:variable name="timestamp">
		<xsl:call-template name="Timestamp" />
	</xsl:variable>


	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- E L E M E N T - T E M P L A T E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template name="OfferGroupTemp">
		<OffersGroup xmlns="http://www.iata.org/IATA/EDIST">
			<AirlineOffers>
				<TotalOfferQuantity>
					<xsl:value-of select="count(.//sita:PriceAvailabilityBinding)" />
				</TotalOfferQuantity>
				<Owner>
					<xsl:value-of select="$owner" />
				</Owner>
				<xsl:for-each select=".//sita:PriceAvailabilityBinding">
					<xsl:variable name="rphCount"
						select="count(.//sita:AvailJourneyBinding)" />
					<xsl:variable name="rphOut"
						select="./sita:AvailJourneyBinding[1]/@AvailJourneyRPH" />
					<xsl:variable name="rphIn"
						select="./sita:AvailJourneyBinding[2]/@AvailJourneyRPH" />
					<xsl:variable name="offerNo" select="position()" />
					<xsl:variable name="seqSearch" select="./@SequenceNumber" />
					<xsl:for-each select="//sita:TripPrice">
						<xsl:if test="$seqSearch = ./@SequenceNumber">
							<AirlineOffer>
								<OfferID Owner="{$owner}">
									<xsl:value-of select="$offerNo" />
								</OfferID>
								<TimeLimits>
									<OfferExpiration Timestamp="{$timestamp}" />
								</TimeLimits>
								<TotalPrice>
									<DetailCurrencyPrice>
										<Total Code="{.//sita:BaseFare/@CurrencyCode}">
											<xsl:value-of select=".//sita:ItinTotalFare/sita:BaseFare/@Amount" />
										</Total>
										<Details>
											<Detail>
												<SubTotal Code="{.//sita:BaseFare/@CurrencyCode}">
													<xsl:value-of select=".//sita:ItinTotalFare/sita:BaseFare/@Amount" />
												</SubTotal>
												<Application>Base Fare</Application>
											</Detail>
										</Details>
									</DetailCurrencyPrice>
								</TotalPrice>
								<PricedOffer>
									<xsl:for-each select=".//sita:PTC_FareBreakdown">
										<xsl:variable name="offerID" select="generate-id(.)" />
										<OfferPrice OfferItemID="{concat(position(), '#', $offerID)}">
											<RequestedDate>
												<PriceDetail>
													<TotalAmount>
														<SimpleCurrencyPrice Code="{.//sita:BaseFare/@CurrencyCode}">
															<xsl:value-of
																select="sum((.//sita:PassengerFare/sita:Taxes/sita:Tax/@Amount | .//sita:PassengerFare/sita:BaseFare/@Amount)[number(.) = .]) " />
														</SimpleCurrencyPrice>
													</TotalAmount>
													<BaseAmount
														Code="{.//sita:PassengerFare/sita:BaseFare/@CurrencyCode}">
														<xsl:value-of
															select=".//sita:PassengerFare/sita:BaseFare/@Amount" />
													</BaseAmount>
													<Taxes>
														<Total
															Code="{.//sita:PassengerFare/sita:BaseFare/@CurrencyCode}">
															<xsl:value-of
																select="sum((.//sita:PassengerFare/sita:Taxes/sita:Tax/@Amount)[number(.) = .])" />
														</Total>
													</Taxes>
												</PriceDetail>
												<Associations>
													<AssociatedTraveler>
														<TravelerReferences>
															<xsl:choose>
																<xsl:when test=".//sita:PassengerTypeQuantity/@Code = 'ADT'">
																	<xsl:text>SH1</xsl:text>
																</xsl:when>
																<xsl:when test=".//sita:PassengerTypeQuantity/@Code = 'CHN'">
																	<xsl:text>SH2</xsl:text>
																</xsl:when>
																<xsl:when test=".//sita:PassengerTypeQuantity/@Code = 'INF'">
																	<xsl:text>SH3</xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>SH1</xsl:text>
																</xsl:otherwise>
															</xsl:choose>
														</TravelerReferences>
													</AssociatedTraveler>
												</Associations>
											</RequestedDate>
											<!-- <FareDetail> <FareComponent> <FareBasis> <FareBasisCode> 
												<Code> <xsl:value-of select=".//sita:FareBasisCode[1]" /> </Code> </FareBasisCode> 
												</FareBasis> </FareComponent> </FareDetail> -->
										</OfferPrice>
									</xsl:for-each>
									<Associations>
										<ApplicableFlight>
											<OriginDestinationReferences>
												<xsl:choose>
													<xsl:when test="$rphCount = 2">
														<xsl:text>OD1 OD2</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>OD1</xsl:text>
													</xsl:otherwise>
												</xsl:choose>
											</OriginDestinationReferences>

											<FlightReferences>
												<xsl:call-template name="lookupFlightKey">
													<xsl:with-param name="rph" select="$rphOut" />
												</xsl:call-template>
												<xsl:if test="$rphCount = 2">
													<xsl:call-template name="lookupFlightKey">
														<xsl:with-param name="rph" select="$rphIn" />
													</xsl:call-template>
												</xsl:if>
											</FlightReferences>

											<xsl:for-each select="//sita:AvailJourneyOption">
												<xsl:if test="$rphOut = .//@RPH">
													<xsl:for-each select="./sita:Flight">
														<xsl:variable name="segRef">
															<xsl:call-template name="lookupSegKeys">
																<xsl:with-param name="rph" select=".//@RPH" />
															</xsl:call-template>
														</xsl:variable>
														<FlightSegmentReference ref="{$segRef}">
															<Cabin>
																<CabinDesignator>
																	<xsl:text>M</xsl:text>
																</CabinDesignator>
															</Cabin>
														</FlightSegmentReference>
													</xsl:for-each>
												</xsl:if>
											</xsl:for-each>
											<xsl:if test="$rphCount = 2">
												<xsl:for-each select="//sita:AvailJourneyOption">
													<xsl:if test="$rphIn = .//@RPH">
														<xsl:for-each select="./sita:Flight">
															<xsl:variable name="segRef">
																<xsl:call-template name="lookupSegKeys">
																	<xsl:with-param name="rph" select=".//@RPH" />
																</xsl:call-template>
															</xsl:variable>
															<FlightSegmentReference ref="{$segRef}">
																<Cabin>
																	<CabinDesignator>
																		<xsl:text>M</xsl:text>
																	</CabinDesignator>
																</Cabin>
															</FlightSegmentReference>
														</xsl:for-each>
													</xsl:if>
												</xsl:for-each>
											</xsl:if>
										</ApplicableFlight>
									</Associations>
								</PricedOffer>
							</AirlineOffer>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</AirlineOffers>
		</OffersGroup>
	</xsl:template>

	<xsl:template name="AnonymousTravelerTemp">
		<AnonymousTravelerList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:for-each
				select=".//sita:TripPrice[1]//sita:PTC_FareBreakdowns//sita:PassengerTypeQuantity">
				<xsl:if test="./@Code = 'ADT'">
					<AnonymousTraveler ObjectKey="SH1">
						<PTC Quantity="1">ADT</PTC>
					</AnonymousTraveler>
				</xsl:if>
				<xsl:if test="./@Code = 'CHN'">
					<AnonymousTraveler ObjectKey="SH2">
						<PTC Quantity="1">CHN</PTC>
					</AnonymousTraveler>
				</xsl:if>
				<xsl:if test="./@Code = 'INF'">
					<AnonymousTraveler ObjectKey="SH3">
						<PTC Quantity="1">INF</PTC>
					</AnonymousTraveler>
				</xsl:if>
			</xsl:for-each>
		</AnonymousTravelerList>
	</xsl:template>

	<xsl:template name="FlightSegmentListTemp">
		<FlightSegmentList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:for-each select=".//sita:Flight">
				<FlightSegment SegmentKey="{concat('SEG', position())}">
					<Departure>
						<AirportCode>
							<xsl:value-of select="./sita:DepartureAirport/@LocationCode" />
						</AirportCode>
						<Date>
							<xsl:value-of select="substring(./@DepartureDateTime, 0, 11)" />
						</Date>
						<Time>
							<xsl:value-of select="substring(./@DepartureDateTime, 12, 5)" />
						</Time>
						<AirportName>
						</AirportName>
					</Departure>
					<Arrival>
						<AirportCode>
							<xsl:value-of select=".//sita:ArrivalAirport/@LocationCode" />
						</AirportCode>
						<Date>
							<xsl:value-of select="substring(./@ArrivalDateTime, 0, 11)" />
						</Date>
						<Time>
							<xsl:value-of select="substring(./@ArrivalDateTime, 12, 5)" />
						</Time>
						<AirportName>
							<xsl:value-of select=".//sita:ArrivalAirport/@LocationCode" />
						</AirportName>
					</Arrival>
					<MarketingCarrier>
						<AirlineID>
							<xsl:value-of select=".//sita:MarketingAirline/@Code" />
						</AirlineID>
						<Name></Name>
						<FlightNumber>
							<xsl:value-of select="./@FlightNumber" />
						</FlightNumber>
					</MarketingCarrier>
					<OperatingCarrier>
						<AirlineID>
							<xsl:value-of select=".//sita:OperatingAirline/@Code" />
						</AirlineID>
						<Name></Name>
						<FlightNumber>
							<xsl:value-of select="./@FlightNumber" />
						</FlightNumber>
					</OperatingCarrier>
					<Equipment>
						<AircraftCode>
							<xsl:value-of select=".//sita:Equipment/@AirEquipType" />
						</AircraftCode>
						<Name>
							<xsl:value-of select=".//sita:Equipment/@AirEquipType" />
						</Name>
					</Equipment>
					<!-- <FlightDetail> <FlightDuration> <Value> <xsl:call-template name="durationTemp"> 
						<xsl:with-param name="beginning" select=".//@DepartureDateTime" /> <xsl:with-param 
						name="end" select=".//@ArrivalDateTime" /> </xsl:call-template> </Value> 
						</FlightDuration> </FlightDetail> -->
				</FlightSegment>
			</xsl:for-each>
		</FlightSegmentList>
	</xsl:template>

	<xsl:template name="FlightListTemp">
		<FlightList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:for-each select=".//sita:AvailJourneyOption">
				<Flight FlightKey="{concat('FL', position())}">
					<!-- <Journey> <Time> <xsl:value-of select="./Duration" /> </Time> </Journey> -->
					<SegmentReferences>
						<xsl:call-template name="lookupSegKeys">
							<xsl:with-param name="rph" select=".//@RPH" />
						</xsl:call-template>
					</SegmentReferences>
				</Flight>
			</xsl:for-each>
		</FlightList>
	</xsl:template>

	<xsl:template name="OriginDestinationTemp">
		<OriginDestinationList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:variable name="journeyCount"
				select="count(.//sita:AvailableJourney[1]/sita:AvailJourneyOption)" />
			<xsl:for-each select=".//sita:AvailableJourney">
				<xsl:variable name="index" select="position()" />
				<xsl:variable name="flightCount" select="count(./sita:AvailJourneyOption)+1" />
				<OriginDestination OriginDestinationKey="{concat('OD',position())}">
					<DepartureCode>
						<xsl:value-of select="./sita:DepartureAirport/@LocationCode" />
					</DepartureCode>
					<ArrivalCode>
						<xsl:value-of select="./sita:ArrivalAirport/@LocationCode" />
					</ArrivalCode>
					<FlightReferences>
						<xsl:for-each select="./sita:AvailJourneyOption">
							<xsl:choose>
								<xsl:when test="$index = 1">
									<xsl:value-of select="concat('FL',position(),' ')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat('FL',position()+$journeyCount,' ')" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</FlightReferences>
				</OriginDestination>
			</xsl:for-each>
		</OriginDestinationList>
	</xsl:template>

	<xsl:template name="PriceClassListTemp">
		<PriceClassList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:for-each select="exsl:node-set($uniquePriceClasses)/PriceClass">
				<PriceClass ObjectKey="{./@id}">
					<Name>
						<xsl:value-of
							select="concat(.//@ResBookDesigCode, '-',.//sita:FareReference)" />
					</Name>
					<Code>
						<xsl:value-of select=".//@ResBookDesigCode" />
					</Code>
					<FareBasisCode>
						<Code>
							<xsl:value-of select=".//sita:FareReference" />
						</Code>
					</FareBasisCode>
				</PriceClass>
			</xsl:for-each>
		</PriceClassList>
	</xsl:template>


	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- M A I N - T E M P L A T E -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//sita:Error">
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
				<AirShoppingRS TimeStamp="{$timestamp}" Version="15.2"
					TransactionIdentifier="a" xmlns="http://www.iata.org/IATA/EDIST"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
					xsi:schemaLocation="http://www.iata.org/IATA/EDIST ../AirShoppingRS.xsd">
					<Document>
						<Name>KRONOS NDC GATEWAY</Name>
						<ReferenceVersion>1.0</ReferenceVersion>
					</Document>
					<Success />
					<AirShoppingProcessing />
					<ShoppingResponseIDs>
						<Owner>
							<xsl:value-of select="$owner" />
						</Owner>
						<ResponseID>
							<xsl:value-of select=".//@AXITransactionIdentifier" />
						</ResponseID>
					</ShoppingResponseIDs>
					<xsl:call-template name="OfferGroupTemp" />
					<DataLists>
						<xsl:call-template name="AnonymousTravelerTemp" />
						<xsl:call-template name="FlightSegmentListTemp" />
						<xsl:call-template name="FlightListTemp" />
						<xsl:call-template name="OriginDestinationTemp" />
					</DataLists>
					<Metadata>
						<Other>
							<OtherMetadata>
								<CurrencyMetadatas>
									<CurrencyMetadata MetadataKey="{.//sita:BaseFare/@CurrencyCode}">
										<Decimals>2</Decimals>
									</CurrencyMetadata>
								</CurrencyMetadatas>
							</OtherMetadata>
							<OtherMetadata>
								<DescriptionMetadatas>
									<DescriptionMetadata MetadataKey="ID1" />
								</DescriptionMetadatas>
							</OtherMetadata>
						</Other>
					</Metadata>
				</AirShoppingRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
