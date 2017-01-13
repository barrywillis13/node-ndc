<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
	xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="exsl ex ota env"
	xmlns:ota="http://www.opentravel.org/OTA/2003/05" xmlns:common="http://sita.aero/common/1/0"
	xmlns="http://www.iata.org/IATA/EDIST" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:output method="xml" indent="yes" />

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- G L O B A L - V A R I A B L E S -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:variable name="owner" select=".//ota:MarketingAirline[1]/@Code" />

	<xsl:variable name="timestamp">
		<xsl:call-template name="Timestamp" />
	</xsl:variable>

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

	<xsl:template name="PricedFlightOffersTemp">
		<PricedFlightOffers>
			<xsl:for-each select=".//ota:AirItineraryPricingInfo">
				<PricedFlightOffer>
					<OfferID Owner="{$owner}"></OfferID>
					<OfferPrice OfferItemID="{position()}">
						<RequestedDate>
							<PriceDetail>
								<TotalAmount>
									<SimpleCurrencyPrice Code="{.//ota:BaseFare/@CurrencyCode}">
										<xsl:value-of
											select="sum((.//ota:PassengerFare/ota:Taxes/ota:Tax/@Amount | .//ota:PassengerFare/ota:BaseFare/@Amount)[number(.) = .]) " />
									</SimpleCurrencyPrice>
								</TotalAmount>
								<BaseAmount Code="{.//ota:BaseFare/@CurrencyCode}">
									<xsl:value-of select=".//ota:PassengerFare/ota:BaseFare/@Amount" />
								</BaseAmount>
								<Taxes>
									<Total Code="{.//ota:BaseFare/@CurrencyCode}">
										<xsl:value-of
											select="sum((.//ota:PassengerFare/ota:Taxes/ota:Tax/@Amount)[number(.) = .])" />
									</Total>
								</Taxes>
							</PriceDetail>
							<Associations>
								<AssociatedTraveler>
									<TravelerReferences>
										<xsl:choose>
											<xsl:when test=".//ota:PassengerTypeQuantity/@Code = 'ADT'">
												<xsl:text>SH1</xsl:text>
											</xsl:when>
											<xsl:when test=".//ota:PassengerTypeQuantity/@Code = 'CHN'">
												<xsl:text>SH2</xsl:text>
											</xsl:when>
											<xsl:when test=".//ota:PassengerTypeQuantity/@Code = 'INF'">
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
						<!-- <FareDetail> -->
						<!-- <FareComponent> -->
						<!-- <FareBasis> -->
						<!-- <FareBasisCode> -->
						<!-- <Code></Code> -->
						<!-- </FareBasisCode> -->
						<!-- </FareBasis> -->
						<!-- </FareComponent> -->
						<!-- </FareDetail> -->
					</OfferPrice>
					<TimeLimits>
						<OfferExpiration Timestamp="{$timestamp}" />
					</TimeLimits>
					<Associations>
						<ApplicableFlight>
							<OriginDestinationReferences></OriginDestinationReferences>
							<FlightReferences></FlightReferences>
							<FlightSegmentReference ref="">
								<Cabin>
									<CabinDesignator>
										<xsl:text>M</xsl:text>
									</CabinDesignator>
								</Cabin>
							</FlightSegmentReference>
						</ApplicableFlight>
						<!-- <PriceClass> -->
						<!-- <PriceClassReference></PriceClassReference> -->
						<!-- </PriceClass> -->
					</Associations>
				</PricedFlightOffer>
			</xsl:for-each>
		</PricedFlightOffers>
	</xsl:template>

	<xsl:template name="AnonymousTravelerTemp">
		<AnonymousTravelerList xmlns="http://www.iata.org/IATA/EDIST">
			<xsl:for-each select=".//ota:PTC_FareBreakdowns//ota:PassengerTypeQuantity">
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
		<FlightSegmentList>
			<xsl:for-each select=".//ota:FlightSegment">
				<FlightSegment SegmentKey="{concat('SEG', ./@RPH)}">
					<Departure>
						<AirportCode>
							<xsl:value-of select="./ota:DepartureAirport/@LocationCode" />
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
							<xsl:value-of select=".//ota:ArrivalAirport/@LocationCode" />
						</AirportCode>
						<Date>
							<xsl:value-of select="substring(./@ArrivalDateTime, 1, 10)" />
						</Date>
						<Time>
							<xsl:value-of select="substring(./@ArrivalDateTime, 12, 5)" />
						</Time>
						<!-- <AirportName></AirportName> -->
					</Arrival>
					<!-- <OperatingCarrier> -->
					<!-- <AirlineID></AirlineID> -->
					<!-- <Name></Name> -->
					<!-- <FlightNumber></FlightNumber> -->
					<!-- </OperatingCarrier> -->
					<MarketingCarrier>
						<AirlineID>
							<xsl:value-of select=".//ota:MarketingAirline/@Code" />
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
			<xsl:for-each select=".//ota:FlightSegment">
				<xsl:variable name="index" select="position()" />
				<OriginDestination OriginDestinationKey="{concat('OD',position())}">
					<DepartureCode>
						<xsl:value-of select="./ota:DepartureAirport/@LocationCode" />
					</DepartureCode>
					<ArrivalCode>
						<xsl:value-of select="./ota:ArrivalAirport/@LocationCode" />
					</ArrivalCode>
					<FlightReferences>
						<xsl:value-of select="concat('FL', position())" />
					</FlightReferences>
				</OriginDestination>
			</xsl:for-each>
		</OriginDestinationList>
	</xsl:template>

	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
	<!-- M A I N - T E M P L A T E -->
	<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//faultstring">
				<env:Envelope>
					<env:Body>
						<env:Fault>
							<faultstring><xsl:value-of select="." /></faultstring>
							<!-- <faultstring><xsl:value-of select="./env:faultstring" /></faultstring> -->
						</env:Fault>
					</env:Body>
				</env:Envelope>
			</xsl:when>
			<xsl:otherwise>
				<FlightPriceRS TimeStamp="{$timestamp}" Version="15.2"
					TransactionIdentifier="a" xmlns="http://www.iata.org/IATA/EDIST"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
					<Document>
						<Name>ATHENA NDC GATEWAY</Name>
						<ReferenceVersion>1.0</ReferenceVersion>
					</Document>
					<Success />
					<ShoppingResponseIDs>
						<Owner>
							<xsl:value-of select="$owner" />
						</Owner>
						<ResponseID></ResponseID>
					</ShoppingResponseIDs>
					<xsl:call-template name="PricedFlightOffersTemp" />
					<DataLists>
						<AnonymousTravelerList>
							<AnonymousTraveler ObjectKey="">
								<PTC Quantity=""></PTC>
							</AnonymousTraveler>
						</AnonymousTravelerList>
						<xsl:call-template name="FlightSegmentListTemp" />
						<xsl:call-template name="FlightListTemp" />
						<xsl:call-template name="OriginDestinationTemp" />
						<!-- <xsl:call-template name="PriceClassListTemp" /> -->
					</DataLists>
					<Metadata>
						<Other>
							<OtherMetadata>
								<CurrencyMetadatas>
									<CurrencyMetadata MetadataKey="{.//ota:BaseFare/@CurrencyCode}">
										<Decimals>2</Decimals>
									</CurrencyMetadata>
								</CurrencyMetadatas>
							</OtherMetadata>
							<!-- <OtherMetadata> -->
							<!-- <DescriptionMetadatas> -->
							<!-- <DescriptionMetadata MetadataKey="ID1"> -->
							<!-- <AugmentationPoint> -->
							<!-- <AugPoint></AugPoint> -->
							<!-- </AugmentationPoint> -->
							<!-- </DescriptionMetadata> -->
							<!-- </DescriptionMetadatas> -->
							<!-- </OtherMetadata> -->
						</Other>
					</Metadata>
				</FlightPriceRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>