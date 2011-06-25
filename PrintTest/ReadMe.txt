Sample: PrintTest

Description: This sample shows the basics of converting a UIWebView to a pdf for viewing and printing. A page is loaded from the web and the user can either email the auto-generated pdf or use QuickLook for printing. 

Notes: In a normal situation if you are in control of the data, for instance if you want to generate a pdf from images and text from within your app, you would use Core Graphics. The advantage there is that you can control how the pages get split up. In this simple example the text gets cropped in an undesirable way.

Thanks : 

Brent Nycum (http://itsbrent.net/2011/06/printing-converting-uiwebview-to-pdf/) - Original idea for conversion procedure

Change Log: 

1.0 - Initial code drop