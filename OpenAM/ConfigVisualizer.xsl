<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


    <xsl:template match="/">
        <html>
            <head>
                <script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js"></script>
                <script>
                    function toggle(e) {
                        c = e.nextElementSibling.firstChild;
                        c.style.display = (c.style.display == 'table-cell') ? 'none' : 'table-cell';
                        return false;
                    }
                    function toggleAll(e) {
                        var c = e.parentNode.parentNode.nextElementSibling.nextElementSibling;
                        while (c != null) {
                            d = c.firstChild;
                            if (d.style.display == 'table-cell') {
                                d.style.display = 'none';
                                e.innerHTML = '[+]'
                            } else {
                                d.style.display = 'table-cell';
                                e.innerHTML = '[-]'
                            }
                            c = c.nextElementSibling.nextElementSibling.nextElementSibling;
                        }
                        return false;
                    }
                    function setSelected(e) {
                        var sib = e.parentNode.children;
                        for (var i in sib) {
                                sib[i].className =  '';
                        }
                        e.className = 'selected';
                    }
                </script>
                <style>
                    @import url(http://fonts.googleapis.com/css?family=Raleway:400,100,700);
                    body { font-family: Raleway, Helvetica; }
                    .container { margin: 0 175px; width: 700px; }
                    .h2 { background-color: #FAFAFA; margin: -10px auto 40px auto; padding: 20px; width: inherit; border-radius: 10px; }
                    h1, h2, h3 { font-weight: 100; }
                    h1, { font-size: 48px; }
                    h2 { margin: 0 auto auto -20px; color: #6D8C61; background: linear-gradient(to left, #fafafa 0%,#ffffff 100%); padding-left: 20px; }
                    h3 { margin-top: 35px; }
                    table { font-size: 12px; width: 100%; border-spacing: 1px; }
                    th { background-color: #9ECC8D; font-weight: 700; text-shadow: 1px 1px 1px #FFF; }
                    tr:nth-child(odd) { background-color: #D9F2D0; }
                    tr:nth-child(even) { background-color: #E6F2E1; }
                    tr:hover { background-color: #C0DEB6; }
                    th, td { padding: 3px 6px; }
                    ul { list-style-type: none; padding: 0;}
                    .ln { width: 15px; text-align: right; background-color: #9ECC8D }
                    .details { max-width: 600px; font-size: 12px; overflow: scroll; margin: 10px; display: none; font-family: courier; border-bottom-right-radius: 5px; border-bottom-left-radius: 5px; background: white; cursor: text; padding: 5px 20px;}
                    .attribute-value { font-weight: 700; }
                    .toggle-details { cursor: pointer; }
                    .toggle-all { float: right; cursor: pointer; }
                    .blank { display: none; }
                    .logo { font-size: 48px; margin: 0; text-align: right; }
                    .toc { position: fixed; top: 0px; left: 15px; width: 150px; }
                    .toc ul { background: #FAFAFA; border-radius: 10px; padding: 10px 0; margin: 0 auto; }
                    .toc li { margin: 0; padding: 0 10px; padding: 5px 10px; text-align: right; text-shadow: 1px 1px 1px #FFF; }
                    .toc li:hover { background: #FFF; }
                    .toc li.selected { background-color: #FFF; background: linear-gradient(to right, #FAFAFA 0%, #FFF 100%) }
                    .toc a { color: black; text-decoration: none; display: block }
                    .prettyprint { border: 0 ! important;}
                </style>
            </head>
            <body>

                <!-- TOC -->

                <div class="toc">
                    <h1 class="logo">&#x2699;</h1>
                    <ul>
                        <li id="tab1" onclick="setSelected(this)"><a href="#naming">Naming Service</a></li>
                        <li onclick="setSelected(this)"><a href="#agents">Agents</a></li>
                        <li onclick="setSelected(this)"><a href="#authentication">Authentication</a></li>
                        <li onclick="setSelected(this)"><a href="#datastores">Data Stores</a></li>
                        <li onclick="setSelected(this)"><a href="#policies">Policies</a></li>
                        <li onclick="setSelected(this)"><a href="#federation">Federation</a></li>
                    </ul>
                </div>
                <div class="container">
                    <h1>export-svc-cfg</h1>

                    <!-- Naming Service -->

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
                                <tr class="toggle-details" onclick="toggle(this);">
                                    <td class="ln"><xsl:value-of select="position()" /></td>
                                    <td><xsl:value-of select="AttributeValuePair[Attribute/@name='serverid']/Value"/></td>
                                    <td><xsl:value-of select="@name"/></td>
                                    <td><xsl:value-of select="AttributeValuePair[Attribute/@name='parentsiteid']/Value"/></td>
                                </tr>
                                <tr>
                                    <td colspan="4" class="details">
                                        <ul>
                                            <xsl:for-each select="AttributeValuePair[Attribute/@name='serverconfigxml']">
                                                <li>
                                                    <pre class="prettyprint lang-xml"><xsl:value-of select="Value" /></pre>
                                                </li>
                                            </xsl:for-each>
                                            <br />
                                            <xsl:for-each select="AttributeValuePair[Attribute/@name='serverconfig']/Value">
                                                    <li>
                                                        <span class="attribute-name"><xsl:value-of select="." /></span>
                                                    </li>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                                <tr class="blank"></tr>
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
                                <tr class="toggle-details" onclick="toggle(this);">
                                    <td class="ln"><xsl:value-of select="position()" /></td>
                                    <td><xsl:value-of select="@name"/></td>
                                    <td><xsl:value-of select="SubConfiguration/AttributeValuePair[Attribute/@name='primary-siteid']/Value"/></td>
                                    <td><xsl:value-of select="SubConfiguration/AttributeValuePair[Attribute/@name='primary-url']/Value"/></td>
                                    <xsl:variable name="siteName" select="@name" />
                                    <td><xsl:value-of select="count(//SubConfiguration[@id='server' and AttributeValuePair[Attribute/@name='parentsiteid']/Value=$siteName])"/></td>
                                </tr>
                                <tr>
                                    <td colspan="5" class="details">
                                        <ul>
                                                <xsl:for-each select="//Service[@name='iPlanetAMSessionService']/Configuration/GlobalConfiguration/SubConfiguration/AttributeValuePair">
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
                        </table>
                    </div>

                    <!-- Agents -->

                    <a name="agents"></a>
                    <div class="h2">
                        <h2>Agents</h2>
                        <xsl:for-each select="//Service[@name='AgentService']/Configuration/OrganizationConfiguration">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Agent Name</th>
                                    <th>Agent Type</th>
                                </tr>
                                <xsl:for-each select="SubConfiguration">
                                    <xsl:sort select="@id"/>
                                    <tr class="toggle-details" onclick="toggle(this);">
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                        <td><xsl:value-of select="@id" /></td>
                                    </tr>
                                    <tr >
                                        <td colspan="3" class="details">
                                            <ul>
                                                <xsl:for-each select="AttributeValuePair">
                                                <xsl:sort select="Attribute/@name"/>
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
                            </table>
                        </xsl:for-each>
                    </div>

                    <!-- Authentication -->

                    <a name="authentication"></a>
                    <div class="h2">
                        <h2>Authentication</h2>

                        <h3>All core settings</h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Realm</th>
                                </tr>
                                <xsl:for-each select="//Service[@name='iPlanetAMAuthService']/Configuration/OrganizationConfiguration[@name!='/sunamhiddenrealmdelegationservicepermissions']">
                                    <xsl:sort select="@name"/>
                                    <tr class="toggle-details" onclick="toggle(this);">
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="details">
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
                            </table>

                        <xsl:for-each select="//Service[contains(@name, 'sunAMAuth') and count(Configuration/OrganizationConfiguration) &gt; 0 ]">
                            <xsl:sort select="@name"/>
                            <h3><xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Realm</th>
                                    <th>AuthLevel</th>
                                </tr>
                                <xsl:for-each select="Configuration/OrganizationConfiguration[@name!='/sunamhiddenrealmdelegationservicepermissions']">
                                    <xsl:sort select="@name"/>
                                    <tr>
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                        <td><xsl:value-of select="AttributeValuePair[contains(Attribute/@name,'Level')]/Value" /></td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each>
                    </div>

                    <!-- Data Stores -->

                    <a name="datastores"></a>
                    <div class="h2">
                        <h2>Data Stores</h2>
                        <xsl:for-each select="//Service[@name='sunIdentityRepositoryService']/Configuration/OrganizationConfiguration[@name!='/sunamhiddenrealmdelegationservicepermissions']">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Data Store Name</th>
                                    <th>DS Type</th>
                                </tr>
                                <xsl:for-each select="SubConfiguration">
                                    <xsl:sort select="@id"/>
                                    <tr class="toggle-details" onclick="toggle(this);">
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                        <td><xsl:value-of select="@id" /></td>
                                    </tr>
                                    <tr >
                                        <td colspan="3" class="details">
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
                            </table>
                        </xsl:for-each>
                    </div>

                    <!-- Policies -->

                    <a name="policies"></a>
                    <div class="h2">
                        <h2>Policies</h2>
                        <xsl:for-each select="//Service[@name='iPlanetAMPolicyService']/Configuration/OrganizationConfiguration[@name != '/sunamhiddenrealmdelegationservicepermissions']">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>
                                        Policy Name
                                        <span id="x" class="toggle-all" onclick="toggleAll(this)">[+]</span>
                                    </th>
                                </tr>
                                <xsl:for-each select="SubConfiguration[@name='Policies']/SubConfiguration">
                                    <xsl:sort select="@name"/>
                                    <tr class="toggle-details" onclick="toggle(this);">
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="details">
                                            <ul>
                                                <xsl:for-each select="AttributeValuePair[Attribute/@name='xmlpolicy']">
                                                    <li>
                                                        <pre class="prettyprint lang-xml"><xsl:value-of select="Value" /></pre>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr class="blank"></tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each>
                    </div>

                    <!-- Federation -->

                    <a name="federation"></a>
                    <div class="h2">
                        <h2>Federation</h2>
                        <xsl:for-each select="//Service[@name='sunFMSAML2MetadataService']/Configuration/OrganizationConfiguration">
                            <xsl:sort select="@name"/>
                            <h3>Realm: <xsl:value-of select="@name" /></h3>
                            <table>
                                <tr>
                                    <th></th>
                                    <th>Entity Name</th>
                                </tr>
                                <xsl:for-each select="SubConfiguration">
                                    <xsl:sort select="@name"/>
                                    <tr class="toggle-details" onclick="toggle(this);">
                                        <td class="ln"><xsl:value-of select="position()" /></td>
                                        <td><xsl:value-of select="@name" /></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="details">
                                            <ul>
                                                <xsl:for-each select="AttributeValuePair">
                                                    <li>
                                                        <pre class="prettyprint lang-xml"><xsl:value-of select="Value" /></pre>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr class="blank"></tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each>
                    </div>


                </div>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
