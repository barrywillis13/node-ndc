<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ota="http://www.opentravel.org/OTA/"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ex="http://exslt.org/dates-and-times">
	<xsl:output method="xml" indent="yes" />


	<xsl:template match="/">
		<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
			<soap:Body>
		<sita:SITA_AirfareRulesRQ xmlns:sita="http://www.sita.aero/PTS/fare/2005/12/RulesRQ" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ota="http://www.opentravel.org/OTA/2003/05" Version="0.03">
                <ota:OTA_AirRulesRQ Version="2.001">
                    <ota:POS>
                        <ota:Source AirportCode="BER" ISOCountry="DE" PseudoCityCode="AE2D">
                            <ota:RequestorID ID="XS" ID_Context="CRSCode" Type="7"/>
                            <ota:BookingChannel Type="1"/>
                        </ota:Source>
                        <ota:Source>
                            <ota:RequestorID ID="RsiG7-78fGd-BDk0d-5Bdo0" ID_Context="Airfare" Type="7"/>
                        </ota:Source>
                        <ota:Source>
                            <ota:RequestorID ID="23259762" ID_Context="IATA_Number" Type="13"/>
                        </ota:Source>
                    </ota:POS>
                    <ota:RuleReqInfo>
                        <ota:DepartureDate><xsl:value-of select="concat(.//Departure/Date, 'T', .//Departure/Time, ':00')"/></ota:DepartureDate>
                        <ota:FareReference><xsl:value-of select="//FareBasisCode/Code"/></ota:FareReference>
                        <ota:RuleInfo/>
                        <ota:FilingAirline Code="{//AirlineID}"/>
                        <ota:DepartureAirport LocationCode="{//Departure/AirportCode}"/>
                        <ota:ArrivalAirport LocationCode="//Arrival/AirportCode"/>
                    </ota:RuleReqInfo>
                </ota:OTA_AirRulesRQ>
                <sita:AdditionalRulesRQData>
                    <sita:References>
                        <sita:Ref1>gepy01(user(ber,f1,&lt;&gt;,y,dept(&lt;&gt;,&lt;&gt;),&lt;&gt;,&lt;&gt;,&lt;&gt;),pf2(y,[agency(ae2d,'23259762',n)],[],[],[],n,&lt;&gt;),&lt;&gt;)</sita:Ref1>
                        <sita:Ref2>4721060atnadty0010000100atpx</sita:Ref2>
                    </sita:References>
                </sita:AdditionalRulesRQData>
            </sita:SITA_AirfareRulesRQ>
					</soap:Body>
				</soap:Envelope>
	</xsl:template>

</xsl:stylesheet>
