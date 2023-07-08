import processing.serial.*; //import the Serial library
Serial myPort;  //the Serial port object
String val;
float[] vals;
Table table; 
String fileName;
//int numReadings = 500; //keeps track of how many readings you'd like to take before writing the file. 
//int readingCounter = 0; //counts each reading to compare to numReadings. 
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
void setup() {
  size(200, 200); //make our canvas 200 x 200 pixels big
  //  initialize your serial port and set the baud rate to 9600
  //println(Serial.list());
  myPort = new Serial(this, Serial.list()[3], 9600);
  myPort.bufferUntil('\n');
  table = new Table();
  table.addColumn("id"); //This column stores a unique identifier for each record. We will just count up from 0 - so your first reading will be ID 0, your second will be ID 1, etc. 

  //the following adds columns for time. You can also add milliseconds. See the Time/Date functions for Processing: https://www.processing.org/reference/ 
  //table.addColumn("year");
  //table.addColumn("month");
  //table.addColumn("day");
  table.addColumn("hour");
  table.addColumn("minute");
  table.addColumn("second");
  table.addColumn("millis");

  //the following are dummy columns for each data value. Add as many columns as you have data values. Customize the names as needed. Make sure they are in the same order as the order that Arduino is sending them!
  table.addColumn("yaw");
  table.addColumn("pressure");
}
void draw() {
  //we can leave the draw method empty, 
  //because all our programming happens in the serialEvent (see below)
}

void serialEvent( Serial myPort) {
  //put the incoming data into a String - 
  //the '\n' is our end delimiter indicating the end of a complete packet
  val = myPort.readStringUntil('\n');
  //make sure our data isn't empty before continuing
  try {
    val = trim(val);
    println(val);
    vals = float(split(val, ' '));
    TableRow newRow = table.addRow(); //add a row for this new reading
    newRow.setInt("id", table.getRowCount() - 1);//record a unique identifier (the row's index)

    //record time stamp
    //newRow.setInt("year", year());
    //newRow.setInt("month", month());
    //newRow.setInt("day", day());
    newRow.setInt("hour", hour());
    newRow.setInt("minute", minute());
    newRow.setInt("second", second());
    newRow.setInt("millis", millis());
    //record sensor information. Customize the names so they match your sensor column names. 
    newRow.setFloat("yaw", vals[0]);
    newRow.setFloat("pressure", vals[1]);
    //readingCounter++; 
    //if (readingCounter % numReadings ==0)//The % is a modulus, a math operator that signifies remainder after division. The if statement checks if readingCounter is a multiple of numReadings (the remainder of readingCounter/numReadings is 0)
    //{
    //fileName = str(year()) + str(month()) + str(day()) + str(table.lastRowIndex()); //this filename is of the form year+month+day+readingCounter
    saveTable(table, "data/raw_data"+str(hour())+str(minute())+str(second())+".csv"); //Woo! save it to your computer. It is ready for all your spreadsheet dreams.
    //}
  }
  catch(Exception e) {
    e.printStackTrace();
  }


  //if (val != null) {
  //  //trim whitespace and formatting characters (like carriage return)
  //  val = trim(val);
  //  println(val);
  //  vals = float(split(val, ' '));
  //  TableRow newRow = table.addRow(); //add a row for this new reading
  //  newRow.setInt("id", table.lastRowIndex());//record a unique identifier (the row's index)

  //  //record time stamp
  //  newRow.setInt("year", year());
  //  newRow.setInt("month", month());
  //  newRow.setInt("day", day());
  //  newRow.setInt("hour", hour());
  //  newRow.setInt("minute", minute());
  //  newRow.setInt("second", second());

  //  //record sensor information. Customize the names so they match your sensor column names. 
  //  newRow.setFloat("yaw", vals[0]);
  //  newRow.setFloat("pressure", vals[1]);
  //  readingCounter++; 
  //  if (readingCounter % numReadings ==0)//The % is a modulus, a math operator that signifies remainder after division. The if statement checks if readingCounter is a multiple of numReadings (the remainder of readingCounter/numReadings is 0)
  //  {
  //    fileName = str(year()) + str(month()) + str(day()) + str(table.lastRowIndex()); //this filename is of the form year+month+day+readingCounter
  //    saveTable(table, fileName); //Woo! save it to your computer. It is ready for all your spreadsheet dreams.
  //  }
  //}
}
