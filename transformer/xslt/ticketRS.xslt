<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="ex" xmlns:common="http://sita.aero/common/2/0" >

	<xsl:output method="xml" indent="yes" />

	<xsl:variable name="timestamp">
		<xsl:call-template name="Timestamp" />
	</xsl:variable>
	
	<xsl:template name="Timestamp">
		<xsl:param name="datestr" select="ex:date-time()" />
		<xsl:value-of select="substring($datestr,1,19)" />
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
			<xsl:otherwise>
				<OrderViewRS xmlns="http://www.iata.org/IATA/EDIST"
					Version="15.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
					<Document />
					<Success />
					<Response>
						<OrderViewProcessing />
						<Passengers>
							<xsl:for-each select="//PassengerName">
								<Passenger>
									<Name>
										<Surname>
											<xsl:value-of select=".//common:Surname" />
										</Surname>
										<Given>
											<xsl:value-of select=".//common:GivenName" />
										</Given>
									</Name>
								</Passenger>
							</xsl:for-each>
						</Passengers>
						<Order>
							<OrderID Owner="AI"><xsl:value-of select="//BookingReferenceId/@ID" /></OrderID>
							<OrderItems>
								<OrderItem />
							</OrderItems>
						</Order>
						<TicketDocInfos>
							<TicketDocInfo>
								<TicketDocument>
									<TicketDocNbr><xsl:value-of select="//TicketItemInfo/@TicketNumber" /></TicketDocNbr>
									<Type>
										<Code><xsl:value-of select="//BookingReferenceId/@Type" /></Code>
									</Type>
									<NumberofBooklets><xsl:value-of select="count(//PassengerName)"/></NumberofBooklets>
									<DateOfIssue><xsl:value-of select="substring-before($timestamp, 'T')"/></DateOfIssue>
								</TicketDocument>
								<PassengerReference />
							</TicketDocInfo>
						</TicketDocInfos>
					</Response>
				</OrderViewRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>