##Step 1
Add the following to the export-svc-cfg document, below the XML declaration in the 1st line:

```
<?xml-stylesheet type="text/xsl" href="ConfigVisualizer.xsl"?>
```

##Step 2
Run the following command:

```
$ xsltproc --encoding UTF-8 export-svc-cfg.xml ConfigVisualizer.xsl > export-svc-cfg.html
```
