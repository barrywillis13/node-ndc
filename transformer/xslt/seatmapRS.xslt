<?xml version="1.0"?>

<xsl:stylesheet version="2"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://sita.aero/SITA_AirSeatMapRS/4/0"
	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:output method="xml" indent="yes" />

	<xsl:template name="splitChars">
		<xsl:param name="text" />
		<xsl:variable name="remainingText" select="substring-after($text, ' ')" />
		<xsl:choose>
			<xsl:when test="contains($text, ' ')">
				<Characteristic>
					<Code>
						<xsl:value-of select="substring-before($text, ' ')" />
					</Code>
				</Characteristic>
				<xsl:if test="$remainingText != ''">
					<xsl:call-template name="splitChars">
						<xsl:with-param name="text" select="$remainingText" />
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<Characteristic>
					<Code>
						<xsl:value-of select="$text" />
					</Code>
				</Characteristic>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="//faultstring">
				<env:Envelope>
					<env:Body>
						<env:Fault>
							<faultstring>
								<xsl:value-of select="." />
							</faultstring>
						</env:Fault>
					</env:Body>
				</env:Envelope>
			</xsl:when>
		<SeatAvailabilityRS EchoToken="8fdb1c621a7a4454aa3360556e7784d5"
			TimeStamp="2015-12-10T12:39:00Z" Version="15.2"
			TransactionIdentifier="a" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:xsd="http://www.w3.org/2001/XMLSchema">
			<Document>
				<Name>ATHENA NDC GATEWAY</Name>
				<ReferenceVersion>1.0</ReferenceVersion>
			</Document>
			<Success />
			<xsl:for-each select=".//FlightSegmentInfo">
				<Flights>
					<FlightSegmentReferences>
						<xsl:value-of select="concat('SEG', position())" />
					</FlightSegmentReferences>
					<Cabin>
						<Code>M</Code>
						<Definition>ECONOMY</Definition>
						<SeatDisplay>
							<Columns>A</Columns>
							<Columns>B</Columns>
							<Columns>C</Columns>
							<Columns>D</Columns>
							<Columns>E</Columns>
							<Columns>F</Columns>
							<Rows>
								<First>
									<xsl:value-of select="//AirRow[1]/@RowNumber" />
								</First>
								<Last>
									<xsl:value-of select="//AirRow[count(//AirRow)]/@RowNumber" />
								</Last>
							</Rows>
						</SeatDisplay>
					</Cabin>
				</Flights>
			</xsl:for-each>
			<DataLists>
				<FlightSegmentList>
					<xsl:for-each select="//FlightSegmentInfo">
						<FlightSegment SegmentKey="{concat('SEG', position())}">
							<Departure>
								<AirportCode>
									<xsl:value-of select="./DepartureAirport/@LocationCode" />
								</AirportCode>
								<Date>
									<xsl:value-of select="substring-before(./@DepartureDateTime, 'T')" />
								</Date>
								<Time>
									<xsl:value-of
										select="substring(substring-after(./@DepartureDateTime, 'T'), 0, 6)" />
								</Time>
							</Departure>
							<Arrival>
								<AirportCode>
									<xsl:value-of select="./ArrivalAirport/@LocationCode" />
								</AirportCode>
							</Arrival>
							<MarketingCarrier>
								<AirlineID>
									<xsl:value-of select="./MarketingAirline/@Code" />
								</AirlineID>
								<FlightNumber>
									<xsl:value-of select="./@FlightNumber" />
								</FlightNumber>
							</MarketingCarrier>
							<OperatingCarrier>
								<AirlineID>
									<xsl:value-of select="./MarketingAirline/@Code" />
								</AirlineID>
								<FlightNumber>
									<xsl:value-of select="./@FlightNumber" />
								</FlightNumber>
							</OperatingCarrier>
							<Equipment>
								<AircraftCode>
									<xsl:value-of select="./Equipment/@AirEquipType" />
								</AircraftCode>
								<Name>
									<xsl:value-of select="./Equipment/@AirEquipType" />
								</Name>
							</Equipment>
							<ClassOfService>
								<Code>
									<xsl:value-of select="//@CabinType" />
								</Code>
							</ClassOfService>
						</FlightSegment>
					</xsl:for-each>
				</FlightSegmentList>
				<SeatList>
					<xsl:for-each select="//AirRow">
						<xsl:variable name="rowNumber" select="./@RowNumber" />
						<xsl:for-each select=".//AirSeat">
							<Seats ListKey="{concat(./@SeatNumber, $rowNumber, 'SEG1')}">
								<Location>
									<Column>
										<xsl:value-of select="./@SeatNumber" />
									</Column>
									<Row>
										<Number>
											<xsl:value-of select="$rowNumber" />
										</Number>
									</Row>
									<Characteristics>
										<xsl:if test="./@SeatCharacteristics">
											<xsl:call-template name="splitChars">
												<xsl:with-param name="text" select="./@SeatCharacteristics" />
											</xsl:call-template>
										</xsl:if>
									</Characteristics>
								</Location>
							</Seats>
						</xsl:for-each>
					</xsl:for-each>
				</SeatList>
			</DataLists>
			<Metadata>
				<Other>
					<OtherMetadata>
						<CurrencyMetadatas>
							<CurrencyMetadata MetadataKey="EUR">
								<Decimals>2</Decimals>
							</CurrencyMetadata>
						</CurrencyMetadatas>
					</OtherMetadata>
					<OtherMetadata>
						<DescriptionMetadatas>
							<DescriptionMetadata MetadataKey="ID1">
								<AugmentationPoint>
									<AugPoint>
										<a:Logo xmlns:a="http://www.iata.org">http://athena.jrtechnologies.com/ServiceImage/Athena-50x90.png
										</a:Logo>
									</AugPoint>
								</AugmentationPoint>
							</DescriptionMetadata>
						</DescriptionMetadatas>
					</OtherMetadata>
				</Other>
			</Metadata>
		</SeatAvailabilityRS>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>