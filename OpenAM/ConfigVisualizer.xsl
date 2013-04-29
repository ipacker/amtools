<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <head>
                <script>
                    function toggle(e) {
                        c = e.nextElementSibling.firstChild;
                        c.style.display = (c.style.display == 'block') ? 'none' : 'block';
                        return false;
                    }
                </script>
                <style>
                    @import url(http://fonts.googleapis.com/css?family=Raleway:400,100,700);
                    body { font-family: Raleway, Helvetica; }
                    .container { margin: 0 250px; width: 700px; }
                    .h2 { background-color: #FAFAFA; margin: -20px auto 40px auto; padding: 20px; width: inherit; border-radius: 10px; }
                    h1, h2, h3 { font-weight: 100; }
                    h1 { font-size: 48px; }
                    h2 { margin: 0 auto auto -20px; color: #6D8C61; background: linear-gradient(to left, #fafafa 0%,#ffffff 100%); padding-left: 20px; }
                    h3 { margin-top: 35px; }
                    table { font-size: 12px; width: 100%; }
                    th { background-color: #9ECC8D; font-weight: 700; }
                    tr:nth-child(odd) { background-color: #D9F2D0; }
                    tr:nth-child(even) { background-color: #E6F2E1; }
                    tr:hover { background-color: #C0DEB6; }
                    th, td { padding: 3px 6px; }
                    ul { list-style-type: none; padding: 0;}
                    .details { max-width: 600px; font-size: 12px; overflow: scroll; margin: 10px; display: none; font-family: courier; border-radius: 5px; background: white; cursor: text; padding: 5px 20px;}
                    .attribute-name { }
                    .attribute-value { font-weight: 700; }
                    .toggle-details { cursor: pointer; }
                    .blank { display: none; }
                    .toc { position: fixed; top: 75px; left: 20px; background: #FAFAFA; border-radius: 10px; padding: 0; width: 210px; }
                    .toc li { margin: 5px 0; padding: 0 10px; }
                    .toc li:hover { background: #E3E3E3; }
                    .toc a { color: black; text-decoration: none; }
                </style>
            </head>
            <body>
                <div class="toc">
                    <ul>
                        <li><a href="#naming">Naming Service</a></li>
                        <li><a href="#agents">Agents</a></li>
                        <li><a href="#auhn">Authentiation</a></li>
                        <li><a href="#datastores">Data Stores</a></li>
                        <li><a href="#policies">Policies</a></li>
                    </ul>
                </div>
                <div class="container">
                    <h1>&#x2699; export-svc-cfg</h1>
                    <a name="naming"></a>
                    <div class="h2">
                        <h2>Naming Service</h2>
                        <h3>Servers</h3>
                        <table>
                            <tr>
                                <th></th>
                                <th>Server ID</th>
                                <th>Server URL</th>
                                <th>Parent Site</th>
                            </tr>
                            <xsl:for-each select="//SubConfiguration[@id='server']">
                                <xsl:sort select="AttributeValuePair/Value"/>
                                <tr>
                                    <td><xsl:value-of select="position()" /></td>
                                    <td><xsl:value-of select="AttributeValuePair[Attribute/@name='serverid']/Value"/></td>
                                    <td><xsl:value-of select="@name"/></td>
                                    <td><xsl:value-of select="AttributeValuePair[Attribute/@name='parentsiteid']/Value"/></td>
                                </tr>
                            </xsl:for-each>
                        </table>
                        <h3>Sites</h3>
                        <table>
                            <tr>
                                <th></th>
                                <th>Site Name</th>
                                <th>Site ID</th>
                                <th>Primary URL</th>
                                <th># of servers</th>
                            </tr>
                            <xsl:for-each select="//SubConfiguration[@name='com-sun-identity-sites']/SubConfiguration[@id='site']">
                                <xsl:sort select="SubConfiguration/AttributeValuePair[Attribute/@name='primary-siteid']/Value"/>
                                <tr>
                                    <td><xsl:value-of select="position()" /></td>
                                    <td><xsl:value-of select="@name"/></td>
                                    <td><xsl:value-of select="SubConfiguration/AttributeValuePair[Attribute/@name='primary-siteid']/Value"/></td>
                                    <td><xsl:value-of select="SubConfiguration/AttributeValuePair[Attribute/@name='primary-url']/Value"/></td>
                                    <xsl:variable name="siteName" select="@name" />
                                    <td><xsl:value-of select="count(//SubConfiguration[@id='server' and AttributeValuePair[Attribute/@name='parentsiteid']/Value=$siteName])"/></td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </div>

                    <a name="agents"></a>
                    <div class="h2">
                        <h2>Agents</h2>
                        <xsl:for-each select="//Configuration[Instance/@name='agentgroup']/OrganizationConfiguration">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Agent Name</th>
                                    <th>Agent Type</th>
                                </tr>
                                <tr>
                                    <xsl:for-each select="SubConfiguration">
                                        <xsl:sort select="@id"/>
                                        <tr class="toggle-details" onclick="toggle(this);">
                                            <td><xsl:value-of select="position()" /></td>
                                            <td><xsl:value-of select="@name" /></td>
                                            <td><xsl:value-of select="@id" /></td>
                                        </tr>
                                        <tr >
                                            <td colspan="4" class="details">
                                                <ul>
                                                    <xsl:for-each select="AttributeValuePair">
                                                        <li>
                                                            <span class="attribute-name"><xsl:value-of select="Attribute/@name" />=</span>
                                                            <span class="attribute-value"><xsl:value-of select="Value" /></span>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr class="blank"></tr>
                                    </xsl:for-each>
                                </tr>
                            </table>
                        </xsl:for-each>
                    </div>

                    <a name="datastores"></a>
                    <div class="h2">
                        <h2>Data Stores</h2>
                        <xsl:for-each select="//Service[@name='sunIdentityRepositoryService']/Configuration/OrganizationConfiguration">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Data Store Name</th>
                                    <th>DS Type</th>
                                </tr>
                                <tr>
                                    <xsl:for-each select="SubConfiguration">
                                        <xsl:sort select="@id"/>
                                        <tr class="toggle-details" onclick="toggle(this);">
                                            <td><xsl:value-of select="position()" /></td>
                                            <td><xsl:value-of select="@name" /></td>
                                            <td><xsl:value-of select="@id" /></td>
                                        </tr>
                                        <tr >
                                            <td colspan="4" class="details">
                                                <ul>
                                                    <xsl:for-each select="AttributeValuePair">
                                                        <li>
                                                            <span class="attribute-name"><xsl:value-of select="Attribute/@name" />=</span>
                                                            <span class="attribute-value"><xsl:value-of select="Value" /></span>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr class="blank"></tr>
                                    </xsl:for-each>
                                </tr>
                            </table>
                        </xsl:for-each>
                    </div>

                    <a name="policies"></a>
                    <div class="h2">
                        <h2>Policies</h2>
                        <xsl:for-each select="//Service[@name='iPlanetAMPolicyService']/Configuration/OrganizationConfiguration[@name != '/sunamhiddenrealmdelegationservicepermissions']">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Policy Name</th>
                                </tr>
                                <tr>
                                    <xsl:for-each select="SubConfiguration[@name='Policies']/SubConfiguration">
                                        <xsl:sort select="@name"/>
                                        <tr class="toggle-details" onclick="toggle(this);">
                                            <td><xsl:value-of select="position()" /></td>
                                            <td><xsl:value-of select="@name" /></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" class="details">
                                                <ul>
                                                    <xsl:for-each select="AttributeValuePair[Attribute/@name='xmlpolicy']">
                                                        <li>
                                                            <span class="attribute-name"><xsl:value-of select="Value" /></span>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr class="blank"></tr>
                                    </xsl:for-each>
                                </tr>
                            </table>
                        </xsl:for-each>
                    </div>

                </div>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
