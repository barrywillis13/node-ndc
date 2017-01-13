<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common"
	xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="exsl ex ota"
	xmlns:ota="http://www.opentravel.org/OTA/2003/05" xmlns:n1="http://www.iata.org/IATA/EDIST"
	xmlns:common="http://sita.aero/common/1/0" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/">

	<xsl:output method="xml" indent="yes" />

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
				<n1:AirDocCancelRS>
					<n1:Document />
					<n1:Success />
					<n1:Response>
						<n1:DocumentType>
							<n1:TicketDocument>
								<n1:TicketDocNbr></n1:TicketDocNbr>
								<n1:Type>
									<n1:Code>
										<xsl:value-of select=".//TicketingInfo/@FormAndSerialNumber" />
									</n1:Code>
								</n1:Type>
							</n1:TicketDocument>
						</n1:DocumentType>
					</n1:Response>
				</n1:AirDocCancelRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>