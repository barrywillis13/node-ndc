<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ns1="http://sita.aero/SITA_CancelRS/4/0"
	xmlns:common="http://sita.aero/common/2/0">

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
				<OrderCancelRS EchoToken="8fdb1c621a7a4454aa3360556e7784d5"
					TimeStamp="2015-12-10T12:39:00Z" Version="15.2"
					TransactionIdentifier="a" xmlns="http://www.iata.org/IATA/EDIST"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
					<Document />
					<Success />
					<Response>
						<OrderCancelProcessing />
						<OrderReference><xsl:value-of select="//ns1:UniqueID/@ID"/></OrderReference>
					</Response>
				</OrderCancelRS>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>