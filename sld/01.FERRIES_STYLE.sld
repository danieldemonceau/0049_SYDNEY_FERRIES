<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
  xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
    <Name>ferry_style</Name>
    <UserStyle>
      <Title>yellow square point style</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>yellow point</Title>
          <PointSymbolizer>
            <Graphic>
              <ExternalGraphic>
                <OnlineResource xlink:type="simple" xlink:href="https://upload.wikimedia.org/wikipedia/commons/d/db/Blue_Arrow_Up_Darker.png" />
                <Format>image/png</Format>
              </ExternalGraphic>
              <Size>18</Size>
			  <Rotation>
				<ogc:PropertyName>bearing</ogc:PropertyName>
			  </Rotation>
            </Graphic>
          </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
