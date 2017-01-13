<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">

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
			<xsl:otherwise>
				<FareRulesRS xmlns:n1="http://www.iata.org/IATA/EDIST"
					xmlns:ota="http://www.opentravel.org/OTA/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
					Version="15.2" xsi:schemaLocation="http://www.iata.org/IATA/EDIST NDC_FareRulesRS.xsd">
					<Document />
					<Success />
					<Rules>
						<Departure>
							<AirportCode>
								<xsl:value-of select="//DepartureAirport/@LocationCode" />
							</AirportCode>
							<Date>
								<xsl:value-of select="substring-before(//DepartureDate, 'T')" />
							</Date>
						</Departure>
						<Arrival>
							<AirportCode>
								<xsl:value-of select="//ArrivalAirport/@LocationCode" />
							</AirportCode>
						</Arrival>
						<FareBasisCode>
							<Code>
								<xsl:value-of select="normalize-space(//FareReference)" />
							</Code>
						</FareBasisCode>
						<AirlineID>
							<xsl:value-of select="//FilingAirline" />
						</AirlineID>
						<xsl:for-each select="//FareRules/SubSection">
							<Rule>
								<FareRuleCategory>
									<Code>
										<xsl:value-of select="./@SubSectionNumber" />
									</Code>
									<Definition>
										<xsl:value-of select="./@SubTitle" />
									</Definition>
								</FareRuleCategory>
								<xsl:for-each select="./Paragraph/Text">
									<Text>
										<xsl:value-of select="normalize-space(.)" />
									</Text>
								</xsl:for-each>
							</Rule>
						</xsl:for-each>
					</Rules>
				</FareRulesRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>